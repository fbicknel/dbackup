SHELL = /bin/sh

# ifeq ($(BUILDDIR),)
	# BUILDDIR := $(ROOT)/build
# endif
ifeq ($(PREFIX),)
	PREFIX := /usr/local
endif

build:
	@echo $(srcdir)
	# mkdir $(BUILDDIR)
	@echo done

filelist := $$(cat MANIFEST)

install: install_bin install_cron install_etc

install_cron:
	crontab -l | sed -e '/###001borg###/d'| sed -e '$$a30 0  * * * nice -n 19 /root/bin/borgbackup >> /var/log/backup/borgbackup.log 2>&1 ###001borg###' | crontab -

uninstall_cron:
	crontab -l | sed -e '/###@borg@###/d'| crontab -
	crontab -l | sed -e '/###[0-9][0-9][0-9]borg###/d'| crontab -

install_etc:
	test -d $(prefix)/etc/logrotate.d || mkdir -p $(prefix)/etc/logrotate.d
	test -d $(prefix)/etc/borg || mkdir -p $(prefix)/etc/borg
	install -o root -g adm -m 0640 etc/logrotate.d/borgbackup $(prefix)/etc/logrotate.d
	install -o root -g adm -m 0640 etc/patterns $(prefix)/etc/borg
	install -o root -g adm -m 0640 etc/version $(prefix)/etc/borg
	mkdir --parents --mode=700 /var/log/backup

install_bin:
	test -d $(prefix)/root/bin || mkdir -p $(prefix)/root/bin
	for file in $(filelist); do \
		install -o root -g adm -m 0750 $$file $(prefix)/root/bin ; \
	done 

uninstall: uninstall_cron uninstall_bin uninstall_etc

uninstall_bin:
	for file in $(filelist); do \
		rm -f $(prefix)/root/$$file ; \
	done

uninstall_etc:
	-rm -f  $(prefix)/etc/logrotate.d/borgbackup
	-rm -rf $(prefix)/etc/borg

reinstall: uninstall install

.PHONY: install uninstall reinstall install_cron install_bin install_etc uninstall_etc

