################################################################################
# Embtoolkit
# Copyright(C) 2009-2014 Abdoulaye Walsimou GAYE.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
################################################################################
#
# \file         jack2.mk
# \brief        jack2.mk of Embtoolkit.
# \author       Ricardo Crudo <ricardo.crudo@gmail.com>
# \date         Oct 2014
################################################################################

JACK2_NAME	:= jack2
JACK2_VERSION	:= $(call embtk_pkg_version,jack2)
JACK2_SITE	:= https://github.com/jackaudio/jack2/archive
JACK2_PACKAGE	:= v$(JACK2_VERSION).tar.gz
JACK2_SRC_DIR	:= $(embtk_pkgb)/jack2-$(JACK2_VERSION)
JACK2_BUILD_DIR	:= $(embtk_pkgb)/jack2-$(JACK2_VERSION)

JACK2_BINS       := jackd jack_*
JACK2_INCLUDES   := jack
JACK2_LIBS       := jack libjack*
JACK2_PKGCONFIGS := jack.pc
JACK2_SHARES     := man/man1/jack* man/man1/alsa_in.1 man/man1/alsa_out.1

JACK2_CONFIGURE_OPTS	:= $(if $(CONFIG_EMBTK_JACK2_WITH_ALSA),--alsa)
#JACK2_CONFIGURE_OPTS	+= $(if $(CONFIG_EMBTK_JACK2_WITH_DBUS),--dbus)
#JACK2_CONFIGURE_OPTS	+= $(if $(CONFIG_EMBTK_JACK2_WITH_FIREWIRE),--firewire)
#JACK2_CONFIGURE_OPTS	+= $(if $(CONFIG_EMBTK_JACK2_WITH_FREEBOB),--freebob)
#JACK2_CONFIGURE_OPTS	+= $(if $(CONFIG_EMBTK_JACK2_WITH_IIO),--iio)
#JACK2_CONFIGURE_OPTS	+= $(if $(CONFIG_EMBTK_JACK2_WITH_PORTAUDIO),--portaudio)

JACK2_DEPS := libsndfile_install libsamplerate_install
JACK2_DEPS += $(if $(CONFIG_EMBTK_JACK2_WITH_ALSA),alsa-lib_install)
