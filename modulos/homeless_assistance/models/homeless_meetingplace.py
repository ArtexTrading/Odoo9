# -*- coding: utf-8 -*-
# Copyright 2016 Artex Trading <informatica@artextrading.com>
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl).

from openerp import fields, models


class HomelessMeetingPlace(models.Model):
    _name = 'homeless.meetingplace'

    sequence = fields.Integer(
        string='Sequence',
        default=10,
        help='Stop order within the route.')

    name = fields.Char(
        string='Title',
        required=True,
        help='Description for meeting place.')

    route_id = fields.Many2one(
        string='Route',
        comodel_name='homeless.route',
        required=True)

    note = fields.Text(string='Note',
        help='Write any clarification on the meeting place.')
