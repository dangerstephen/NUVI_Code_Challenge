# Nuvi Code Challenge 
Interview code challange sent to me by [NUVI][]

## The Challenge 
This URL (http://bitly.com/nuvi-plz) is an http folder containing a list of zip files. Each zip file contains a bunch of xml files. Each xml file contains 1 news report.

Your application needs to download all of the zip files, extract out the xml files, and publish the content of each xml file to a redis list called “NEWS_XML”.

Make the application idempotent. We want to be able to run it multiple times but not get duplicate data in the redis list.


## Download and Installation

```
git clone https://github.com/dangerstephen/NUVI_Code_Challenge.git
cd NUVI_Code_Challenge
bundle install
```

## Getting Started 
In order for this to work properly we need to use insure we have [Redis][] insalled as we will be posting the list of XML files here. You can [download it here][], otherwise you can move on. 

Now Run the application 

```
ruby nuvi.rb
```
NOTE: This will take awhile to finsih as there are many files

Want to see how many files are currently on the 'NEWS_XML' list? 
Open a new tab in the terminal and type 

```
redis-cli
```
This will open the redis command line. We will now run 

```
LLEN NEWS_XML
```

This will tell us how many files are currently in our 'NEWS_XML' list

To leave the redis command line simply type 

```
exit
```

## How it works

Here is what each line of code does and why I decided to do it this way:
asadfadsfdasfadfadsf



[NUVI]: https://www.nuvi.com
[Redis]: https://redis.io/
[download it here]: https://redis.io/download
