---
layout: single
title: "Notes on Installing an Autopsy Multi-user Cluster"
date: '2020-04-05T09:56:03+09:00'

tags:
  - infosec
  - dfir
  - autopsy
modified_time: ""
---

Note: This is just initial notes to get an autopsy multi-user cluster working. In my setup Autopsy is installed on Linux, and the servers are Linux-based. So far, a fully-Linux setup looks difficult. It appears that Autopsy shared correlation will work, but distributed processing is questionable. More to come later.

## Getting started
Main server - Ubuntu 18.04 - install and upgrade

Speed test: NFS vs Samba (2015) - https://ferhatakgun.com/network-share-performance-differences-between-nfs-smb/

Samba optimize - https://calomel.org/samba_optimize.html
Watch out for chaching.

"Also note that because all computers need to access the shared storage at the same path, you cannot mix operating systems. A Linux system running Solr will not be able to access the shared storage at the same path as a Windows Autopsy client."

I don't understand why this would be true.

### Server 1
*DO NOT USE THE APT PACKAGE* https://www.osradar.com/install-apachemq-ubuntu-18-04/

Setting the service user and group did not work for me. Removing it runs activemq as system - not sure if that is desirable...

Instead try with ```sudo /opt/activemq/bin/activemq start
```

```bash
sudo systemctl restart activemq
systemctl status activemq
```

sudo apt install postgresql
https://www.digitalocean.com/community/tutorials/how-to-install-and-use-postgresql-on-ubuntu-16-04
sudo nano /etc/postgresql/10/main/postgresql.conf

sudo systemctl restart postgresql

**End of server 1 config**

** Server 2**
Create the shared folder and add it to /etc/exports for NFS

If your client is Windows, use Samba instead.

Install Solr
Autopsy is using a very old version of Solr - 4.10.3
https://archive.apache.org/dist/lucene/solr/4.10.3/

https://tecadmin.net/install-apache-solr-on-ubuntu/

If using Solr 8, change solrconfig.xml mergeFactor to mergePolicyFactory.