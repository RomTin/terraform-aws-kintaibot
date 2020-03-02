#!/usr/bin/env python3
import requests
import json
from urllib.parse import parse_qs
from datetime import datetime, timezone, timedelta
import re
import boto3
from transitions import Machine
from enum import Enum
from random import choice

s3 = boto3.resource("s3")
JST = timezone(timedelta(hours=+9), 'JST')
SLACK_TOKEN = "${slack_token}"
USER_ID = "${user_id}"
DESTINATIONS = ${destinations}
BUCKET_NAME = "${bucket_name}"

REGEX = re.compile(".*(${work_start_words}).*|.*(${remote_work_start_words}).*|.*(${work_end_words}).*|.*(${recover_words}).*|.*(${break_start_words}).*|.*(${afk_start_words}).*|.*(${broadcast_words}).*|.*(${cancel_words}).*")
BROADCAST_REGEX = re.compile(".*`(.*)`.*")
CONFIGS = {
    'WORK_START': "${work_start_text}",
    'REMOTE_WORK_START': "${remote_work_start_text}",
    'WORK_END': "${work_end_text}",
    'RECOVER': "${recover_text}",
    'BREAK_START': "${break_start_text}",
    'AFK_START': "${afk_start_text}",
    'BROADCAST': "${broadcast_text}",
    'CANCEL': "${cancel_text}",
}
RESPONSES = {
    'WORK_START': "${work_start_res}",
    'REMOTE_WORK_START': "${remote_work_start_res}",
    'WORK_END': "${work_end_res}",
    'RECOVER': "${recover_res}",
    'BREAK_START': "${break_start_res}",
    'AFK_START': "${afk_start_res}",
    'CANCEL': "${cancel_res}",
}
UNDEFINED_ACTION_TEXT = ${undef_action_text}
ILLEGAL_ACTION_TEXT = ${illegal_action_text}
DIFFERENT_USER_TEXT = ${different_user}

class StateTransitions(Enum):
    WORK_START = 0
    REMOTE_WORK_START = 1
    WORK_END = 2
    RECOVER = 3
    BREAK_START = 4
    AFK_START = 5
    BROADCAST = 6
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
        self.timecard_obj = s3.Object(BUCKET_NAME, self.date.strftime('%Y-%m-%d.csv'))
        self.total_time = {
            State.WORKING.name: list(),
            State.BREAK.name: list(),
            State.AFK.name: list()
        } # work, break, afkのタイムスタンプを [start, end, start, end...] の順で連続して保持する
        self.timecard_body = list()
        try:
            self.timecard_body = self.timecard_obj.get()['Body']
        except Exception as e:
            current_status = State.HOME.name
        else:
            self.timecard_body = self.timecard_body.read().decode('utf-8').split('\n')
            for line in self.timecard_body:
                line = line.split(', ')
                self.total_time[line[4]].append(line[8])
                current_status = line[7] # latest state
        if len(self.total_time[State.WORKING.name]) % 2: # [start, end, ..., start] の場合に、endを今のタイムスタンプで補完する
            self.total_time[State.WORKING.name].append(self.timestamp)
        if len(self.total_time[State.BREAK.name]) % 2:
            self.total_time[State.BREAK.name].append(self.timestamp)
        if len(self.total_time[State.AFK.name]) % 2:
            self.total_time[State.AFK.name].append(self.timestamp)
        self.machine = Machine(model=self, states=WorkingStateMachine.states, initial=current_status, auto_transitions=False)
        self.machine.add_transition(trigger=StateTransitions.WORK_START.name,        source=State.HOME.name,    dest=State.WORKING.name, after='start')
        self.machine.add_transition(trigger=StateTransitions.REMOTE_WORK_START.name, source=State.HOME.name,    dest=State.WORKING.name, after='start')
        self.machine.add_transition(trigger=StateTransitions.WORK_END.name,          source=State.WORKING.name, dest=State.HOME.name,    before='before_end', after='after_end')
        self.machine.add_transition(trigger=StateTransitions.BREAK_START.name,       source=State.WORKING.name, dest=State.BREAK.name,   after='start')
        self.machine.add_transition(trigger=StateTransitions.RECOVER.name,           source=State.BREAK.name,   dest=State.WORKING.name, before='before_end', after='after_end')
        self.machine.add_transition(trigger=StateTransitions.AFK_START.name,         source=State.WORKING.name, dest=State.AFK.name,     after='start')
        self.machine.add_transition(trigger=StateTransitions.RECOVER.name,           source=State.AFK.name,     dest=State.WORKING.name, before='before_end', after='after_end')

    def start(self):
        payload = "{year}, {month}, {day}, {hms}, {state}, start, {span}, {new_state}, {timestamp}".format(
            year = int(self.date.year),
            month = int(self.date.month),
            day = int(self.date.day),
            hms = self.date.strftime("%H:%M:%S"),
            state = self.state,
            span = 0,
            new_state = self.state,
            timestamp = self.timestamp
        )
        self.timecard_body.append(payload)
        self.timecard_obj.put(Body=('\n').join(self.timecard_body).encode())
        return True

    def before_end(self):
        self.__previous_state = self.state # タイムカードに記録するためにSTMの遷移前の状態を一時保存する
        return True

    def after_end(self):
        payload = "{year}, {month}, {day}, {hms}, {state}, end, {span}, {new_state}, {timestamp}".format(
            year = int(self.date.year),
            month = int(self.date.month),
            day = int(self.date.day),
            hms = self.date.strftime("%H:%M:%S"),
            state = self.__previous_state,
            span = 0,
            new_state = self.state,
            timestamp = self.timestamp
        )
        self.timecard_body.append(payload)
        self.timecard_obj.put(Body=('\n').join(self.timecard_body).encode())
        return True

    def rollback(self):
        self.timecard_body = self.timecard_body[:-1]
        self.timecard_obj.put(Body=('\n').join(self.timecard_body).encode())
        return True

    def convert_time(seconds):
        [h, m, s] = [int(t) for t in str(timedelta(seconds=int(seconds))).split(':')]
        return f"{str(h) + '時間' if h != 0 else ''}{str(m) + '分' if m != 0 else ''}{s}秒"

    def get_total_time(self, time_name):
        t = 0
        index = 0
        while(index < len(self.total_time[time_name])):
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
            try:
                res = requests.post(dest, json.dumps({ "text": f"{text} {self.date.strftime('(at %m/%d %H:%M:%S)')}" }))
            except Exception as e:
                raise e
            else:
                continue


def handle(event, context):
    body = parse_qs(event.get('body') or '')
    if body.get('token', [''])[0] != SLACK_TOKEN:
        return { 'statusCode': 400 }
    if body.get('user_id', [''])[0] != USER_ID:
        return { 'statusCode': 200, 'body': json.dumps({'text': choice(DIFFERENT_USER_TEXT + UNDEFINED_ACTION_TEXT) }) }

    timestamp = int(body.get('timestamp', [''])[0].split('.')[0])
    text = body.get('text', [''])[0]
    try:
        g = REGEX.match(text).groups()
        method = next(StateTransitions(index) for index, m in enumerate(g) if m is not None)
    except:
        return { 'statusCode': 200, 'body': json.dumps({'text': choice(UNDEFINED_ACTION_TEXT) }) }

    timecard = WorkingStateMachine(timestamp)
    try:
        timecard.trigger(method.name)
        timecard.broadcast(CONFIGS[method.name])
        return { 'statusCode': 200, 'body': json.dumps({'text': RESPONSES[method.name] +\
            (f"\n```{timecard.get_summary()}```\n```{timecard.get_csv()}```" if timecard.state == State.HOME.name else "") }) }
    except:
        if method.name == StateTransitions.CANCEL.name:
            try:
                timecard.rollback()
                return { 'statusCode': 200, 'body': json.dumps({'text': RESPONSES[method.name] }) }
            except:
                pass
        try:
            g = BROADCAST_REGEX.match(text).groups()
            timecard.broadcast(g[0])
            return { 'statusCode': 200, 'body': json.dumps({'text': RESPONSES[method.name] }) }
        except:
            return { 'statusCode': 200, 'body': json.dumps({'text': choice(ILLEGAL_ACTION_TEXT) }) }