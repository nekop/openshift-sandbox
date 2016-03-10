#!/bin/bash

oadm policy add-scc-to-user hostmount-anyuid system:serviceaccount:openshift-infra:pv-recycler-controller 
