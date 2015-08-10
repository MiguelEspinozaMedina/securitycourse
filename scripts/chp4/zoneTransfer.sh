#!/bin/bash
# Zone transfer using host -l switch

domain=megacorpone.com
for node in $(host -t ns $domain) 
do
	host -l $domain $node |grep "has address"
done
