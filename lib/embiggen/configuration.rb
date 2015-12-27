# encoding: utf-8
require 'set'
require 'embiggen/shortener_list'

module Embiggen
  class Configuration
    class << self
      attr_writer :timeout, :redirects, :shorteners
    end

    def self.timeout
      @timeout ||= 1
    end

    def self.redirects
      @redirects ||= 5
    end

    # From http://longurl.org/services
    def self.shorteners
      @shorteners ||= ShortenerList.new(%w(
        0rz.tw 1link.in 1url.com 2.gp 2big.at 2tu.us 3.ly 307.to 4ms.me
        4sq.com 4url.cc 6url.com 7.ly a.gg a.nf aa.cx abcurl.net ad.vu adf.ly
        adfoc.us adjix.com afx.cc all.fuseurl.com alturl.com amzn.to ar.gy
        arst.ch atu.ca azc.cc b23.ru b2l.me bacn.me bcool.bz bc.vc binged.it
        bit.ly bit.do bizj.us bloat.me bravo.ly bsa.ly budurl.com canurl.com
        chilp.it chzb.gr cl.lk cl.ly clck.ru cli.gs cliccami.info clickthru.ca
        clop.in conta.cc cort.as cot.ag crks.me ctvr.us cutt.us dai.ly
        decenturl.com dfl8.me digbig.com digg.com disq.us dld.bz dlvr.it do.my
        doiop.com dopen.us easyuri.com easyurl.net eepurl.com eweri.com fa.by
        fav.me fb.me fbshare.me ff.im fff.to fire.to firsturl.de firsturl.net
        flic.kr flq.us fly2.ws fon.gs freak.to fuseurl.com fuzzy.to fur.ly
        fwd4.me fwib.net g.ro.lt gizmo.do gl.am go.9nl.com go.ign.com go.usa.gov
        goo.gl goshrink.com gurl.es hex.io hiderefer.com hmm.ph href.in
        hsblinks.com htxt.it huff.to hulu.com hurl.me hurl.ws icanhaz.com
        idek.net ilix.in is.gd its.my ix.lt j.mp jijr.com kl.am klck.me
        korta.nu krunchd.com l9k.net lat.ms liip.to liltext.com linkbee.com
        linkbun.ch liurl.cn ln-s.net ln-s.ru lnk.gd lnk.ms lnkd.in lnkurl.com
        lru.jp lt.tl lurl.no macte.ch mash.to merky.de migre.me miniurl.com
        minurl.fr mke.me moby.to moourl.com mrte.ch myloc.me myurl.in n.pr
        nbc.co nblo.gs nn.nf not.my notlong.com nsfw.in nutshellurl.com nxy.in
        nyti.ms o-x.fr oc1.us om.ly omf.gd omoikane.net on.cnn.com on.mktw.net
        onforb.es orz.se ow.ly ping.fm pli.gs pnt.me politi.co post.ly pp.gg
        profile.to ptiturl.com pub.vitrue.com qlnk.net qte.me qu.tc qy.fi r.im
        rb6.me read.bi readthis.ca reallytinyurl.com redir.ec seomafia.net
        redirx.com retwt.me ri.ms rickroll.it riz.gd rt.nu ru.ly rubyurl.com
        rurl.org rww.tw s4c.in s7y.us safe.mn sameurl.com sdut.us shar.es
        shink.de shorl.com short.ie short.to shortlinks.co.uk shorturl.com
        shout.to show.my shrinkify.com shrinkr.com shrt.fr shrt.st shrten.com
        shrunkin.com simurl.com slate.me smallr.com smsh.me smurl.name sn.im
        snipr.com snipurl.com snurl.com sp2.ro spedr.com srnk.net srs.li
        starturl.com su.pr surl.co.uk surl.hu t.cn t.co t.lh.com ta.gd tbd.ly
        tcrn.ch tgr.me tgr.ph tighturl.com tiniuri.com tiny.cc tiny.ly tiny.pl
        tinylink.in tinyuri.ca tinyurl.com tk tl.gd tmi.me tnij.org tnw.to
        tny.com to to.ly togoto.us totc.us toysr.us tpm.ly tr.im tra.kz
        trunc.it twhub.com twirl.at twitclicks.com twitterurl.net
        twitterurl.org twiturl.de twurl.cc twurl.nl u.mavrev.com u.nu u76.org
        ub0.cc ulu.lu updating.me ur1.ca url.az url.co.uk url.ie url360.me
        url4.eu urlborg.com urlbrief.com urlcover.com urlcut.com urlenco.de
        urli.nl urls.im urlshorteningservicefortwitter.com urlx.ie urlzen.com
        usat.ly use.my vb.ly vgn.am vl.am vm.lc w55.de wapo.st wapurl.co.uk
        wipi.es wp.me x.vu xr.com xrl.in xrl.us xurl.es xurl.jp y.ahoo.it
        yatuc.com ye.pe yep.it yfrog.com yhoo.it yiyd.com youtu.be yuarel.com
        z0p.de zi.ma zi.mu zipmyurl.com zud.me zurl.ws zz.gd zzang.kr ›.ws
        ✩.ws ✿.ws ❥.ws ➔.ws ➞.ws ➡.ws ➨.ws ➯.ws ➹.ws ➽.ws
      ))
    end
  end
end
