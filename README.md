# Cache-lookup-algorithm-simulation
This repository investigates alternative lookup algorithms for an IP→MAC address cache (the local table hosts and routers use after ARP/NDP resolution). The goal is to implement three candidate lookup algorithms in MATLAB, define meaningful performance metrics, and run controlled experiments to compare their behaviour under realistic workloads (e.g. random lookups, skewed popularity, temporally-local access). The focus is on the efficiency of search and update operations rather than on networking functionality beyond the lookup itself.

Objectives

Survey and pick three candidate lookup algorithms appropriate for IP→MAC caches.

Implement each algorithm in MATLAB (lookup, insert, delete, and optional TTL/expiry).

Design and generate workloads that reflect realistic access patterns (uniform, Zipf/Zipf-like skew, and temporal locality).

Measure performance using well-chosen metrics and visualise results.

Draw conclusions and provide recommendations for practical cache design.
