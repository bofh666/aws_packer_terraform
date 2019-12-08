#!/usr/bin/env python
import boto3

print('This script checks if it is possible to run given instance type in given availability zone\n')

itype = input('Please enter instance type: ')
azone = input('Please enter availability zone: ')

ec2 = boto3.client('ec2')

itypes = []

try:
    response = ec2.describe_reserved_instances_offerings(AvailabilityZone=azone)
except ec2.exceptions.ClientError:
    print(f'\nThere\'s no {azone} availability zone in your default region, exiting')
    exit()

for it in response['ReservedInstancesOfferings']:
    itypes.append(it['InstanceType'])

if itype in itypes:
    print(f'\nGreat! Instance type {itype} is available in {azone}')
    exit()
else:
    print(f'\nUnfortunately instance type {itype} is not available in {azone}, please check the list of available types:\n')
    itypes = sorted(set(itypes))
    for it in itypes:
        print(it)



