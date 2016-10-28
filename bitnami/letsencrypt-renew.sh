#!/bin/bash
# Renew Let's Encrypt SSL cert

cd /root/certbot-master/
./letsencrypt-auto --config /etc/letsencrypt/cli.ini -d domain.com -d www.domain.com certonly

if [ $? -ne 0 ]
 then
	ERRORLOG=`tail /var/log/letsencrypt/letsencrypt.log`
	echo -e "The Lets Encrypt Cert has not been renewed! \n \n" $ERRORLOG | mail -s "Lets Encrypt Cert Alert" postmaster@yourdomain.com
 else
	/opt/bitnami/ctlscript.sh restart
fi

exit 0