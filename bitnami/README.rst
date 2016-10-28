########################################
# letsencrypt Binami helper
########################################

============
Letsencrypt Installation
============

Just download the current version of the ACME script and extract it on your server:

.. code-block:: bash

    # Get the necessary scripts from github:
    $ wget https://github.com/letsencrypt/letsencrypt/archive/master.zip
    $ unzip master.zip

    # Change your active directory to the newly created:
    $ cd letsencrypt

    # or folder is an other name
    $ cd certbot-master

    # This step should work with all Bitnami instances.

    # Start the ACME client with the production URL as an option from the command line.
    $ sudo ./letsencrypt-auto --agree-dev-preview --server https://acme-v01.api.letsencrypt.org/directory auth

Just folow the steps from letsencrypt

After finishing the steps above, you will get feedback on the console where you can find your certificates.

.. code-block:: bash

    IMPORTANT NOTES:
     - Congratulations! Your certificate and chain have been saved at
       /full/path/domain.com/fullchain.pem. Your cert will
       expire on 2016-12-31. To obtain a new version of the certificate in
       the future, simply run Let's Encrypt again.

============
Bitnami configuation
============

.. code-block:: bash

    # Edit th config of the app
    $ sudo vi /path/to/apps/<your_application>/conf/httpd-vhosts.conf

    # In my case that would be:
    $ sudo vi /opt/bitnami/apps/wordpress/conf/httpd-vhosts.conf

This step should work on all Bitnami instances relying on Apache.

In the ``httpd-vhosts.conf`` I changed the ``<VirtualHost>`` settings of the three ``SSLCertificateFile`` parameters to point to the correct location of the newly signed certificates. You do not need to care about the file types of the certificates (``.pem``). Those will just work as they only contain plain text. The overall section will look like the following lines:

.. code-block:: bash

    <VirtualHost *:443>
        ServerName domain.com
        ServerAlias www.domain.com
        DocumentRoot "/path/to/htdocs"
        SSLEngine on
        SSLCertificateFile "/full/path/domain.com/cert.pem"
        SSLCertificateKeyFile "/full/path/domain.com/privkey.pem"
        SSLCertificateChainFile "/full/path/domain.com/fullchain.pem"
        Include "/path/to/conf/httpd-app.conf"
    </VirtualHost>

In the  bitnami.conf I changed changed the same lines

.. code-block:: bash

    <VirtualHost _default_:443>
      DocumentRoot "/opt/bitnami/apache2/htdocs"
      SSLEngine on
      SSLCertificateFile "/full/path/domain.com/cert.pem"
      SSLCertificateKeyFile "/full/path/domain.com/privkey.pem"
      SSLCertificateChainFile "/full/path/domain.com/fullchain.pem"
    [...]
    </VirtualHost>

In the next step save and restart your hosting services:

.. code-block:: bash

    # Restart services
    $ sudo /opt/bitnami/ctlscript.sh restart

There should be no error or warning displayed on the console.

Now you should check your domain, if it is working with ``https://``

============
Letsencrypt Renewal
============

Copy the file ``letsencrypt-renew.sh`` into ``/root/`` or other path on your server.

.. code-block:: bash

    # Apply read mod to file
    $ chmod +x letsencrypt-renew.sh 

Copy the file ``cli.ini`` into ``/etc/letsencrypt/`` or other path on your server.

.. code-block:: bash

    # Apply read mod to file
    $ chmod 777 /etc/letsencrypt/cli.ini

Try to run file the file ``letsencrypt-renew.sh``

.. code-block:: bash

    # Run sh script
    $ sh letsencrypt-renew.sh 

============
Letsencrypt Auto-Renewal
============

A practical way to ensure your certificates won’t get outdated is to create a cron job that will periodically execute the automatic renewal command for you. Since the renewal first checks for the expiration date and only executes the renewal if the certificate is less than 30 days away from expiration, it is safe to create a cron job that runs every week or even every day, for instance.

Let's edit the crontab to create a new job that will run the renewal command every week. To edit the crontab for the root user, run:

.. code-block:: bash

    $ sudo crontab -e

Include the following content, all in one line:

.. code-block:: crontab

    30 2 * * 1 /root/letsencrypt-renew.sh >> /var/log/letsencrypt-renew.log

Save and exit. This will create a new cron job that will execute the letsencrypt-auto renew command every Monday at 2:30 am. The output produced by the command will be piped to a log file located at ``/var/log/letsencrypt-renewal.log``.


Commands for RHEL/Fedora/CentOS/Scientific Linux user

.. code-block:: bash

    # Restart cron 
    $ sudo /etc/init.d/crond restart
    
    # OR RHEL/CentOS 5.x/6.x user:
    
    # Restart cron 
    $ service crond restart

    # OR RHEL/Centos Linux 7.x user:
    
    # Restart cron 
    $ systemctl restart crond.service


Commands for Debian Linux user

.. code-block:: bash

    # Restart cron 
    $ sudo /etc/init.d/cron restart
    
    # OR
    
    # Restart cron 
    $ sudo service cron restart


============
Conclusion
============

In this guide, we saw how to install a free SSL certificate from Let’s Encrypt in order to secure a website hosted with Apache. We recommend that you check the official `Let’s Encrypt blog <https://letsencrypt.org/blog/>`_ for important updates from time to time.


