Storify Ruby Gem
================
This is a Ruby interface to the Storify REST-API.

Status
------
* Work-in-progress (expect updates)

Prerequisites
-------------
* Ruby 2.0
* storify.gemspec dependencies
* Storify developer account and API key

TODO
----
* Continue with wrapping API calls
* Formatters for Story Content
* De-couple specs from actual API (i.e. WebMock)


Usage and documentation
-----------------------
To run the tests please ensure you have created a `.userkey.rb` file in the spec directory.
See the `.userkey.rb.sample` file for details.

Note: The Storify API currently requires a password to be entered for
authentication. Please ensure you perform this securely (as you do not want it
to appear in plaintext within your shell profile history or within your script).
The included specs demonstrate masking a password from shell history.


### Setup

Install the gem:
```bash
$ gem install storify
```

Include the `storify` gem in your script:
```ruby
require 'storify'
```


### Configuration

Pass the `Storify::Client` a configuration block when initialized:
```ruby
client = Storify::Client.new do |config|
  config.username = 'YOUR_USERNAME'
  config.api_key  = 'YOUR_API_KEY'
  config.token    = 'YOUR_AUTH_TOKEN (optional)'
end
```

Authenticate your `Storify::Client` to receive your `token` (password required):
```ruby
client.auth('<password>')
```

### Operations

The following operations have currently been implemented:

| Verb    | Operation                           | Paging  | Options | Method               |
| ------- | ----------------------------------- | :-----: | :-----: | -------------------- |
| `POST`  | `/auth`                             | `N/A`   | `YES`   | `client.auth`        |
| `POST`  | `/stories/:username/:slug/editslug` | `N/A`   | `YES`   | `client.edit_slug`   |
| `GET`   | `/stories`                          | `YES`   | `YES`   | `client.stories`     |
| `GET`   | `/stories/:username`                | `YES`   | `YES`   | `client.userstories` |
| `GET`   | `/stories/:username/:slug`          | `YES`   | `YES`   | `client.story`       |
| `GET`   | `/stories/browse/latest`            | `YES`   | `YES`   | `client.latest`      |
| `GET`   | `/stories/browse/featured`          | `YES`   | `YES`   | `client.featured`    |
| `GET`   | `/stories/browse/popular`           | `YES`   | `YES`   | `client.popular`     |
| `GET`   | `/stories/browse/topic/:topic`      | `YES`   | `YES`   | `client.topic`       |


Example: Get a list of stories for a user
```ruby
stories = client.userstories('<any username>')
```

Example: Get an entire story for a user
```ruby
story = client.story('<story slug>','<any username>')
```

Example: Change a story slug and print new slug name
```ruby
puts client.edit_slug('<username>', '<old slug>', <'new slug>')
```


### Paging

For any of the supported methods, you can specify paging options (page, max, per_page).

| Attribute  | Default   | API Limits   |
| ---------- | --------- | ------------ |
| `page`     | `1`       | 1..unbounded |
| `per_page` | `20`      | 1..50        |
| `max`      | `0 (all)` | N/A          |


Retrieve page 3 to the end of the story:
```ruby
p = Storify::Pager.new(page: 3)
story = client.story('<slug>','<username>', pager: p)
```

Retrieve pages 2-3 (inclusive), 10 pages at a time:
```ruby
p = Storify::Pager.new(page: 2, max: 3, per_page: 10)
story = client.story('<slug>','<username>', pager: p)
```

Retrieve the top 20 newest stories:
 ```ruby
p = Storify::Pager.new(page: 1, max: 1, per_page: 20)
story = client.latest(pager: p)
```

Retrieve the top 10 featured stories:
 ```ruby
p = Storify::Pager.new(page: 1, max: 1, per_page: 10)
story = client.featured(pager: p)
```

Retrieve the top 50 popular stories:
 ```ruby
p = Storify::Pager.new(page: 1, max: 1, per_page: 50)
story = client.popular(pager: p)
```

Retrieve the top 10 stories for a topic:
 ```ruby
p = Storify::Pager.new(page: 1, max: 1, per_page: 10)
story = client.popular('<topic>', pager: p)
```


### Options

For any of the supported methods, you can now specify the API version, and
protocol (http/https) at runtime.

Get a story using `version 1` of the API and `http` instead of `https` by default:
```ruby
opts = {:version => :v1, :protocol => :insecure}
story = client.story('<slug>','<username>', options: opts)
```


### Rendering

Render a text-only version of a particular story (e.g. startup digest):
```ruby
story = client.story('austin-startup-digest-for-december-9-2014', 'joshuabaer')
puts story.to_s
```


### Sample Output: Text-only Story
```html
Austin Startup Digest for December 9, 2014
------------------------------------------
Date: 2013-12-09
Author: joshuabaer
Link: http://storify.com/joshuabaer/austin-startup-digest-for-december-9-2014

Welcome to the Austin Startup Digest! Sign up for a weekly email with all of the upcoming startup events at http://startupdigest.com/austin

--- CLICK "NEXT PAGE" AT THE BOTTOM FOR MORE ---

YOU MAY HAVE MISSED
-------------------

[2013-12-03] Nicholle Jaramillo: http://twitter.com/NicholleJ/status/407924506380861441

The Longhorn Startup Demo Day was a huge success with almost 1,000 attendees and amazing pitches from 14 student startups. The keynote by Cotter Cunningham and interview with Mark Cuban made it even better! 
[2013-12-06] @BobMetcalfe: http://twitter.com/BobMetcalfe/status/408945067835944960
[2013-12-06] Joshua Baer: http://twitter.com/JoshuaBaer/status/408791065479495681
[2013-12-06] Josh Kerr: http://twitter.com/joshkerr/status/409048621892382720
[2013-12-06] Joshua Baer: http://twitter.com/JoshuaBaer/status/408771704261836800
[2013-12-06] 3 Day Startup: http://twitter.com/3DayStartup/status/408784271793324032
[2013-12-06] @JoshuaBaer: http://twitter.com/JoshuaBaer/status/408832852172632064

Longhorn Startup is an incredible resource for student entrepreneurs at the University of Texas that gives them college credit for working on their startup - plus incredible speakers, industry mentors, office space and more. We're looking for entrepreneurial students to take our class next semester and mentors from the community to help them. If you know either of them, please introduce me!
[2013-12-02] @LonghornStartup: http://twitter.com/LonghornStartup/status/407532620163981312
[2013-12-08] @BobMetcalfe: http://twitter.com/BobMetcalfe/status/409484847342567424

Pittsburgh import Insurance Zebra had their big launch party... congrats guys!
[2013-12-07] @InsuranceZebra: http://twitter.com/InsuranceZebra/status/409468427019878400
[2013-12-02] @EugeneAustin: http://twitter.com/EugeneAustin/status/407562194524463104
[2013-12-07] @JoshuaBaer: http://twitter.com/JoshuaBaer/status/409162985530068992
[2013-12-06] bartbohn: http://twitter.com/bartbohn/status/408752227143008256
[2013-12-02] Amazon: http://twitter.com/amazon/status/407317990862893056
[2013-12-05] Joshua Baer: http://twitter.com/JoshuaBaer/status/408651728406339584
[2013-12-05] Joshua Baer: http://twitter.com/JoshuaBaer/status/408651138632667136

I'M LOOKING FORWARD TO
----------------------

[2013-12-06] @JacquelinesLife: http://twitter.com/JacquelinesLife/status/409082313402617856
[2013-12-07] @CFDeviceLab: http://twitter.com/CFDeviceLab/status/409173169505710080
[2013-12-06] @damon: http://twitter.com/damon/status/409082835002474497
[2013-12-05] @MyABJ: http://twitter.com/MyABJ/status/408638281551974401

STARTUP JOBS
------------


Want to work at the best address downtown? Join the Capital Factory Jobs group and browse through job postings from some of Austin's hottest startups.

Hiring for your tech startup? Send out a tweet with your job posting link and add @cfstartupjobs so that I will see it and retweet it for you.
[2013-12-08] @SpareFoot: http://twitter.com/SpareFoot/status/409541181698482176

STARTUP AND PRODUCT LAUNCHES
----------------------------

[2013-12-05] @daltounian: http://twitter.com/daltounian/status/408638357842173952
[2013-12-07] @BetaList: http://twitter.com/BetaList/status/409325726438277120
[2013-12-07] @juliehuls: http://twitter.com/juliehuls/status/409176751923683329

IN THE BLOGS
------------

[2013-12-06] @bazaarbrett: http://twitter.com/bazaarbrett/status/409054943039852544

IN THE NEWS
-----------

[2013-12-07] @Mattermark: http://twitter.com/Mattermark/status/409142316041920512
[2013-12-08] @EntMagazine: http://twitter.com/EntMagazine/status/409729292705484800
[2013-12-07] @LonghornStartup: http://twitter.com/LonghornStartup/status/409168104670105600
[2013-12-04] @GreatVeto: http://twitter.com/GreatVeto/status/408099861784190976
[2013-12-05] @ChrisLammert: http://twitter.com/ChrisLammert/status/408662492270043136
[2013-12-05] @ABJBarr: http://twitter.com/ABJBarr/status/408646835700387840
[2013-12-05] @SiliconHillsNew: http://twitter.com/SiliconHillsNew/status/408453653217832961
[2013-12-05] @SiliconHillsNew: http://twitter.com/SiliconHillsNew/status/408648842712588288
[2013-12-05] @EFF: http://twitter.com/EFF/status/408662751834144768
[2013-12-07] @CFStartupNews: http://twitter.com/CFStartupNews/status/409428708777148416

FAVORITE TWEETS
---------------

[2013-12-08] @Taylor_ATX: http://twitter.com/Taylor_ATX/status/409743512456798208
[2013-12-03] @paulg: http://twitter.com/paulg/status/407961403421503488
[2013-12-03] ddayman: http://twitter.com/ddayman/status/407883765482921984
[2013-12-06] @peterostrander: http://twitter.com/peterostrander/status/408804882679078912
[2013-12-07] SciencePorn: http://twitter.com/SciencePorn/status/409182832234213376
```

Special Thanks
--------------
Storify ([@Storify](http://twitter.com/Storify)) for building an awesome product.

License
-------
Released under the MIT License.  See the LICENSE file for further details.
