# Pre-work - *Tippy*

**Tippy** is a tip calculator application for iOS.

Submitted by: **Erika Joun**

Time spent: **7** hours spent in total

## User Stories

The following **required** functionality is complete:

* [x] User can enter a bill amount, choose a tip percentage, and see the tip and total values.

The following **optional** features are implemented:
* [x] Settings page to change the default tip percentage.
* [ ] UI animations
* [ ] Remembering the bill amount across app restarts (if <10mins)
* [ ] Using locale-specific currency and currency thousands separators.
* [x] Making sure the keyboard is always visible and the bill amount is always the first responder. This way the user doesn't have to tap anywhere to use this app. Just launch the app and start typing.

The following **additional** features are implemented:
* [x] Remembering the bill amount after navigating to settings page
* [x] Allowing the option to overwrite tip percentage values
* [x] Remembering the modified tip percentage values as well as setting default values only when app is launched for the first time
* [x] Calculating and automatically displaying the cost of the bill when split between 2, 3, and 4 diners
* [x] Allowing the option to enter the number of diners to calculate the cost for each diner when the bill is split

## Video Walkthrough 

Here's a walkthrough of implemented user stories:

<img src='https://i.imgur.com/XDHeFc6.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Describe any challenges encountered while building the app.

The greatest challenge was handling persistent memory and making sure that everything updated properly whenever the
main screen appeared. Another challenge was figuring out how to programmatically modify the UI elements.

## License

    Copyright 2018 Hye Lim Joun

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
