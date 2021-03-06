include:
  - osg
  - osg.base_setup
  - osg.host_certs


shib-repo:
  pkgrepo.managed:
    - name: shib-el7
    - humanname: Shibboleth (CentOS_7)
    - baseurl: http://download.opensuse.org/repositories/security:/shibboleth/CentOS_7/
    - gpgcheck: 1
    - gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-SHIBBOLETH
    - type: rpm-md
  file.managed:
    - name: /etc/pki/rpm-gpg/RPM-GPG-KEY-SHIBBOLETH
    - source: salt://osg/files/repos/RPM-GPG-KEY-SHIBBOLETH

shib-httpd-conf:
  file.managed:
    - name: /etc/httpd/conf.d/shib.conf
    - source: salt://osg/files/httpd/shib.conf

shib-userdir-conf:
  file.managed:
    - name: /etc/httpd/conf.d/userdir.conf
    - source: salt://osg/files/httpd/userdir.conf

shib-ssl-conf:
  file.managed:
    - name: /etc/httpd/conf.d/ssl.conf
    - source: salt://osg/files/httpd/ssl.conf

osg-shibboleth-cert:
  file.managed:
    - name: /etc/pki/tls/certs/osg-shibboleth.pace.gatech.edu.pem
    - source: salt://osg/files/httpd/selfsignedcert.pem

osg-shibboleth-key:
  file.managed:
    - name: /etc/pki/tls/private/osg-shibboleth.pace.gatech.edu.key.pem
    - source: salt://osg/files/httpd/selfsignedkey.pem

osg-shibboleth-service:
  pkg.latest:
    - name: shibboleth
  service.running:
    - enable: true
    - name: shibd

osg-shibboleth-httpd:
  pkg.latest:
    - pkgs:
      - httpd
      - mod_ssl
  service.running:
    - enable: true
    - name: httpd
    - watch:
      - file: /etc/httpd/conf.d/shib.conf
      - file: /etc/httpd/conf.d/userdir.conf
      - file: /etc/httpd/conf.d/ssl.conf
    - require:
      - osg-shibboleth-service
