#!/bin/sh

# https://github.com/Free-Software-for-Android/AdAway/wiki/HostsSources
gzsrc='
http://winhelp2002.mvps.org/hosts.txt
http://hosts-file.net/.%5Cad_servers.txt
http://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext
https://raw.githubusercontent.com/4ft35t/android-hosts/master/ad.txt
'
ungzsrc='
https://adaway.org/hosts.txt
'

whitelist='
localhost
360buyimg.com
'
rm /tmp/hosts

for i in $gzsrc
do
    wget -S --header="accept-encoding: gzip" -O- $i | gzip -d | awk '!/^#/' >> /tmp/hosts
done

for i in $ungzsrc
do
    wget -S  -O- $i | awk '!/^#/' >> /tmp/hosts
done

for i in $whitelist
do
    sed -i "/${i}/d" /tmp/hosts
done

awk '$2 {print "address=/"$2"/127.0.0.1"}' < /tmp/hosts |awk '!a[$0]++' | sed 's/\r//g' > adaway.conf

rm /tmp/hosts
