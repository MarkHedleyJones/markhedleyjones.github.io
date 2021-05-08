---
layout: post
title:  "Automatic Shopping List"
date:   2018-10-01 09:01:13 +0000
permalink: /projects/barcode-scanner-shopping-list
image: https://raw.githubusercontent.com/MarkHedleyJones/markhedleyjones.github.io/master/media/barcode-scanner-shopping-list/shopping-list-pc.jpg
description: Scan empty products to automatically add them to your shopping list
---
<p>
  Source code for this project is available on <a href="https://github.com/MarkHedleyJones/homeDisplay">GitHub</a>.
</p>
<p style="text-align: justify;">
  Making shopping lists can be frustrating. Forgetting to take your shopping list to the supermarket, even more-so. This project combines a Raspberry Pi 3 with a barcode scanner in order to keep a Trello based shopping list up-to-date. This way your list is always accessible (via your mobile) and is up-to-date.
</p>
<p style="text-align: justify;">
  The idea is simple – track what goes into your rubbish bin so you can buy replacements when you're next at the supermarket. To make that possible, a Raspberry Pi 3 running a webserver, Google Chrome web-browser and a barcode scanner was sufficient. By connecting the Raspberry Pi to the internet via WiFi, the shopping list could be stored in the cloud (using the Trello API). That was most of the functionality I wanted and it worked really well. Over time, more features were added, such as:
</p>
<ul>
  <li>Timer to turn off the screen and barcode scanner at night and when nobody was home</li>
  <li>Live weather (four day forecast) with expected precepitation graph</li>
  <li>Countdown timer (top left under date) to a goal</li>
  <li>Shared calendars (via Google Calendar)</li>
  <li>Todo list (via Trello)</li>
</ul>
<p>Watch the video below to see it in action. You can see the scanned items appear both on the cell-phone and in the list on the left-hand side of the phone.</p>
<p style="text-align: center;">
    <iframe src="https://www.youtube.com/embed/rjEYKrj8YEo?controls=1" width="690" height="390" allowfullscreen="allowfullscreen"></iframe>
</p>

<h2 style="text-align: left;">Details Summary</h2>
<ul>
<li style="text-align: left;">The PC maintained a database of products and their barcode numbers. When an unknown item was scanned, it appeard as "Unknown Item (08 5321...)" Whrere the numbers in brackets are the start of the item's barcode number. Then, on Trello, you could it to matche the name of the item (e.g. "Baking Soda"). The PC would see this change and record the item description and barcode number into a separate <a style="text-align: left;" href="https://github.com/MarkHedleyJones/Household-Barcode-Database">GitHub repository</a>. This made adding new products quick and simple.</li>
<li style="text-align: left;">The barcode scanner appears as a keyboard input device. Scanning an item causes the virtual keyboard to enter the barcode number followed by enter.</li>
<li style="text-align: left;">Google chrome was automatically launched in `kiosk` mode at boot-up. This removes the titlebar and keeps it in full-screen mode.</li>
<li style="text-align: left;">The webserver was created using Flask in Python.</li>
<li style="text-align: left;">The material design lite CSS kit was used to style the page.</li>
</ul>
