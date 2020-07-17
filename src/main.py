#!/usr/bin/env python3
import json
import os
from urllib.parse import parse_qs
from urllib.request import Request, urlopen
from urllib.error import URLError
from datetime import datetime, timezone, timedelta
import re
import boto3
from transitions import Machine
from enum import Enum
from random import choice

s3 = boto3.resource("s3")
JST = timezone(timedelta(hours=+9), 'JST')
SLACK_TOKENS = os.environ['slack_tokens'].split(';')
USER_IDS = os.environ['user_ids'].split(';')
DESTINATIONS = os.environ['destinations'].split(';')
BUCKET_NAME = os.environ['bucket_name']

REGEX = re.compile(
    ".*({}).*|.*({}).*|.*({}).*|.*({}).*|.*({}).*|.*({}).*|.*({}).*|.*({}).*".
    format(os.environ['broadcast_words'], os.environ['work_start_words'],
           os.environ['remote_work_start_words'], os.environ['work_end_words'],
           os.environ['recover_words'], os.environ['break_start_words'],
           os.environ['afk_start_words'], os.environ['cancel_words']))
BROADCAST_REGEX = re.compile(".*`(.*)`.*")
CONFIGS = {
    'BROADCAST': "",
    'WORK_START': os.environ['work_start_text'],
    'REMOTE_WORK_START': os.environ['remote_work_start_text'],
    'WORK_END': os.environ['work_end_text'],
    'RECOVER': os.environ['recover_text'],
    'BREAK_START': os.environ['break_start_text'],
    'AFK_START': os.environ['afk_start_text'],
    'CANCEL': os.environ['cancel_text'],
}
RESPONSES = {
    'BROADCAST': os.environ['broadcast_res'],
    'WORK_START': os.environ['work_start_res'],
    'REMOTE_WORK_START': os.environ['remote_work_start_res'],
    'WORK_END': os.environ['work_end_res'],
    'RECOVER': os.environ['recover_res'],
    'BREAK_START': os.environ['break_start_res'],
    'AFK_START': os.environ['afk_start_res'],
    'CANCEL': os.environ['cancel_res'],
}
UNDEFINED_ACTION_TEXT = os.environ['undef_action_text'].split(';')
ILLEGAL_ACTION_TEXT = os.environ['illegal_action_text'].split(';')
DIFFERENT_USER_TEXT = os.environ['different_user'].split(';')


class StateTransitions(Enum):
    BROADCAST = 0
    WORK_START = 1
    REMOTE_WORK_START = 2
    WORK_END = 3
    RECOVER = 4
    BREAK_START = 5
    AFK_START = 6
    CANCEL = 7


class State(Enum):
    HOME = 0
    WORKING = 1
    BREAK = 2
    AFK = 3


class WorkingStateMachine:
    states = [s.name for s in State]

    def __init__(self, timestamp):
        self.name = 'state'
        self.date = datetime.fromtimestamp(timestamp, JST)
        self.timestamp = timestamp
        self.timecard_obj = s3.Object(BUCKET_NAME,
                                      self.date.strftime('%Y-%m-%d.csv'))
        self.total_time = {
            State.WORKING.name: list(),
            State.BREAK.name: list(),
            State.AFK.name: list()
        }  # work, break, afkのタイムスタンプを [start, end, start, end...] の順で連続して保持する
        self.timecard_body = list()
        current_status = State.HOME.name
        try:
            self.timecard_body = self.timecard_obj.get()['Body'].read().decode(
                'utf-8').split('\n')
            for line in self.timecard_body:
                line = line.split(', ')
                if len(line) == 9:
                    self.total_time[line[4]].append(line[8])
                    current_status = line[7]  # latest state
                else:
                    self.timecard_body = list()
                    break
        except:
            pass
        if len(self.total_time[State.WORKING.name]) % 2:
            self.total_time[State.WORKING.name].append(self.timestamp)
        if len(self.total_time[State.BREAK.name]) % 2:
            self.total_time[State.BREAK.name].append(self.timestamp)
        if len(self.total_time[State.AFK.name]) % 2:
            self.total_time[State.AFK.name].append(self.timestamp)
        self.machine = Machine(model=self,
                               states=WorkingStateMachine.states,
                               initial=current_status,
                               auto_transitions=False)
        self.machine.add_transition(trigger=StateTransitions.WORK_START.name,
                                    source=State.HOME.name,
                                    dest=State.WORKING.name,
                                    after='start')
        self.machine.add_transition(
            trigger=StateTransitions.REMOTE_WORK_START.name,
            source=State.HOME.name,
            dest=State.WORKING.name,
            after='start')
        self.machine.add_transition(trigger=StateTransitions.WORK_END.name,
                                    source=State.WORKING.name,
                                    dest=State.HOME.name,
                                    before='before_end',
                                    after='after_end')
        self.machine.add_transition(trigger=StateTransitions.BREAK_START.name,
                                    source=State.WORKING.name,
                                    dest=State.BREAK.name,
                                    after='start')
        self.machine.add_transition(trigger=StateTransitions.RECOVER.name,
                                    source=State.BREAK.name,
                                    dest=State.WORKING.name,
                                    before='before_end',
                                    after='after_end')
        self.machine.add_transition(trigger=StateTransitions.AFK_START.name,
                                    source=State.WORKING.name,
                                    dest=State.AFK.name,
                                    after='start')
        self.machine.add_transition(trigger=StateTransitions.RECOVER.name,
                                    source=State.AFK.name,
                                    dest=State.WORKING.name,
                                    before='before_end',
                                    after='after_end')

    def start(self):
        payload = "{year}, {month}, {day}, {hms}, {state}, start, {span}, {new_state}, {timestamp}".format(
            year=int(self.date.year),
            month=int(self.date.month),
            day=int(self.date.day),
            hms=self.date.strftime("%H:%M:%S"),
            state=self.state,
            span=0,
            new_state=self.state,
            timestamp=self.timestamp)
        self.timecard_body.append(payload)
        self.timecard_obj.put(Body=('\n').join(self.timecard_body).encode())
        return True

    def before_end(self):
        self.__previous_state = self.state  # タイムカードに記録するためにSTMの遷移前の状態を一時保存する
        return True

    def after_end(self):
        payload = "{year}, {month}, {day}, {hms}, {state}, end, {span}, {new_state}, {timestamp}".format(
            year=int(self.date.year),
            month=int(self.date.month),
            day=int(self.date.day),
            hms=self.date.strftime("%H:%M:%S"),
            state=self.__previous_state,
            span=0,
            new_state=self.state,
            timestamp=self.timestamp)
        self.timecard_body.append(payload)
        self.timecard_obj.put(Body=('\n').join(self.timecard_body).encode())
        return True

    def rollback(self):
        if len(self.timecard_body) == 0:
            raise Exception("Failed to rollback due to empty log.")
        try:
            self.timecard_body = self.timecard_body[:-1]
            self.timecard_obj.put(
                Body=('\n').join(self.timecard_body).encode())
            return True
        except Exception as e:
            raise e

    def convert_time(seconds):
        [h, m, s
         ] = [int(t) for t in str(timedelta(seconds=int(seconds))).split(':')]
        return f"{str(h) + '時間' if h != 0 else ''}{str(m) + '分' if m != 0 else ''}{s}秒"

    def get_total_time(self, time_name):
        t = 0
        index = 0
        while (index < len(self.total_time[time_name])):
            l = int(self.total_time[time_name][index])
            r = int(self.total_time[time_name][index + 1])
            t += r - l
            index += 2
        return t

    def get_summary(self):
        total_work = self.get_total_time(State.WORKING.name)
        break_time = self.get_total_time(State.BREAK.name)
        afk_time = self.get_total_time(State.AFK.name)
        total_work -= (break_time + afk_time)
        return f"""\
勤務時間: {WorkingStateMachine.convert_time(total_work)}
休憩時間: {WorkingStateMachine.convert_time(break_time)}
離席時間: {WorkingStateMachine.convert_time(afk_time)}"""

    def get_csv(self):
        return ('\n').join(self.timecard_body)

    def broadcast(self, text):
        for dest in DESTINATIONS:
            data = json.dumps({
                "text":
                f"{text} {self.date.strftime('(at %m/%d %H:%M:%S)')}"
            }).encode("utf-8")
            request = Request(url=dest,
                              data=data,
                              method='POST',
                              headers={'Content-Type': 'application/json'})
            try:
                response = urlopen(request)
            except URLError as e:
                if hasattr(e, 'reason'):
                    print('We failed to reach a server.')
                    print('Reason: ', e.reason)
                elif hasattr(e, 'code'):
                    print('The server couldn\'t fulfill the request.')
                    print('Error code: ', e.code)


def handle(event, context):
    body = parse_qs(event.get('body') or '')
    if body.get('token', [''])[0] not in SLACK_TOKENS:
        return {'statusCode': 400}
    if body.get('user_id', [''])[0] not in USER_IDS:
        return {
            'statusCode':
            200,
            'body':
            json.dumps(
                {'text': choice(DIFFERENT_USER_TEXT + UNDEFINED_ACTION_TEXT)})
        }

    timestamp = int(body.get('timestamp', [''])[0].split('.')[0])
    text = body.get('text', [''])[0]
    timecard = WorkingStateMachine(timestamp)

    # 本文をパースして実行するアクションを取得する。取得不可能な場合はUNDEFを返す
    try:
        g = REGEX.match(text).groups()
        method = next(
            StateTransitions(index) for index, m in enumerate(g)
            if m is not None)
    except:
        return {
            'statusCode': 200,
            'body': json.dumps({'text': choice(UNDEFINED_ACTION_TEXT)})
        }

    # BROADCAST以外の正しいアクションを受け取っているので実行する。triggerに失敗した場合はCANCEL or 不正な遷移なのでそれぞれ処理する
    try:
        timecard.trigger(method.name)
        timecard.broadcast(CONFIGS[method.name])
        return { 'statusCode': 200, 'body': json.dumps({'text': RESPONSES[method.name] +\
            (f"\n```{timecard.get_summary()}```\n```{timecard.get_csv()}```" if timecard.state == State.HOME.name else "") }) }
    except:
        # 本文にバッククォートが含まれる場合、アクションがBROADCASTならそれを実行し、それ以外ならUNDEFを返す
        if method.name == StateTransitions.BROADCAST.name:
            try:
                b = BROADCAST_REGEX.match(text).groups()[0]
                timecard.broadcast(b)
                return {
                    'statusCode': 200,
                    'body': json.dumps({'text': RESPONSES[method.name]})
                }
            except:
                pass
        # CSVを一つ巻き戻して取り消し可能なら取り消す
        elif method.name == StateTransitions.CANCEL.name:
            try:
                timecard.rollback()
                timecard.broadcast(CONFIGS[method.name])
                return {
                    'statusCode': 200,
                    'body': json.dumps({'text': RESPONSES[method.name]})
                }
            except:
                pass
        return {
            'statusCode': 200,
            'body': json.dumps({'text': choice(ILLEGAL_ACTION_TEXT)})
        }
