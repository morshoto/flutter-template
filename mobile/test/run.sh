#!/bin/sh

flutter test --machine > machine.log
cat machine.log | tojunit --output ./coverage/TEST-results.xml
echo 'Tests done.'
flutter pub global run dart_dot_reporter machine.log
xunit-viewer -r ./coverage/TEST-results.xml -o ./coverage/index.html
