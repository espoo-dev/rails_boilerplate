#!/bin/bash
rake db:exists && rake db:migrate || rake db:setup

rm /app/tmp/pids/*

rails s -b 0
