class Quranmodel {
  String? ayahTitle;
  int? ayahid;
  int? ayahNumber;
  String? pageTag;
  int? pageid;
  String? rubuTag;
  int? rubuhizbid;
  String? hizbTag;
  int? hizbid;
  String? juzTag;
  int? juzid;
  String? suraName;
  String? suraTag;
  int? chapterNumber;
  String? meaning;
  String? contentAr;
  String? ibrahimWalk;
  String? abdulbasitMurattal;
  String? basfar;
  String? assudais;
  String? alafasy;
  String? algamdi;
  String? alshatri;
  String? alhudhaify;
  String? alhusary;
  String? arrefai;
  String? alakhdar;
  String? almuaiqly;
  String? jebril;
  String? minshawi;
  String? attablawi;
  String? alshuraym;
  String? abdulbasit;
  String? ayyub;
  String? bukhatir;
  String? khanUrdu;
  String? ibrahimdosary;
  String? jazaery;
  String? kabiri;
  String? juhayne;
  String? matroud;
  String? neena;
  String? jaber;
  String? alaqimy;
  String? hajjaj;
  String? baliyev;
  String? bosnian;
  String? abbad;
  String? hussarym;
  String? hussaryMujawad;
  String? tunaji;
  String? qahdhani;
  String? albana;
  String? alqasim;
  String? alqatami;
  String? alajamy;
  String? suraImages;
  String? contentEn;
  String? ayahImage;
  String? contentEs;
  String? contentNl;
  String? contentRu;
  String? contentSo;
  String? contentMy;
  String? contentZh;
  String? contentUz;
  String? contentUr;
  String? contentUg;
  String? contentTt;
  String? contentTr;
  String? contentTg;
  String? contentSv;
  String? contentSq;
  String? contentPt;
  String? contentJa;
  String? contentIt;
  String? contentId;
  String? contentHi;
  String? contentFr;
  String? contentFa;
  String? contentDe;
  String? contentAz;
  String? contentArj;
  String? contentAm;
  String? contentEnSi;
  String? contentSw;
  String? contentEnTr;

  Quranmodel(
      {this.ayahTitle,
      this.ayahid,
      this.ayahNumber,
      this.pageTag,
      this.pageid,
      this.rubuTag,
      this.rubuhizbid,
      this.hizbTag,
      this.hizbid,
      this.juzTag,
      this.juzid,
      this.suraName,
      this.suraTag,
      this.chapterNumber,
      this.meaning,
      this.contentAr,
      this.ibrahimWalk,
      this.abdulbasitMurattal,
      this.basfar,
      this.assudais,
      this.alafasy,
      this.algamdi,
      this.alshatri,
      this.alhudhaify,
      this.alhusary,
      this.arrefai,
      this.alakhdar,
      this.almuaiqly,
      this.jebril,
      this.minshawi,
      this.attablawi,
      this.alshuraym,
      this.abdulbasit,
      this.ayyub,
      this.bukhatir,
      this.khanUrdu,
      this.ibrahimdosary,
      this.jazaery,
      this.kabiri,
      this.juhayne,
      this.matroud,
      this.neena,
      this.jaber,
      this.alaqimy,
      this.hajjaj,
      this.baliyev,
      this.bosnian,
      this.abbad,
      this.hussarym,
      this.hussaryMujawad,
      this.tunaji,
      this.qahdhani,
      this.albana,
      this.alqasim,
      this.alqatami,
      this.alajamy,
      this.suraImages,
      this.contentEn,
      this.ayahImage,
      this.contentEs,
      this.contentNl,
      this.contentRu,
      this.contentSo,
      this.contentMy,
      this.contentZh,
      this.contentUz,
      this.contentUr,
      this.contentUg,
      this.contentTt,
      this.contentTr,
      this.contentTg,
      this.contentSv,
      this.contentSq,
      this.contentPt,
      this.contentJa,
      this.contentIt,
      this.contentId,
      this.contentHi,
      this.contentFr,
      this.contentFa,
      this.contentDe,
      this.contentAz,
      this.contentArj,
      this.contentAm,
      this.contentEnSi,
      this.contentSw,
      this.contentEnTr});

  Quranmodel.fromJson(Map<String, dynamic> json) {
    ayahTitle = json['ayah-title'];
    ayahid = json['ayahid'];
    ayahNumber = json['Ayah_number'];
    pageTag = json['page-tag'];
    pageid = json['pageid'];
    rubuTag = json['rubu-tag'];
    rubuhizbid = json['rubuhizbid'];
    hizbTag = json['hizb-tag'];
    hizbid = json['hizbid'];
    juzTag = json['juz-tag'];
    juzid = json['juzid'];
    suraName = json['sura name'];
    suraTag = json['Sura-tag'];
    chapterNumber = json['chapter_number'];
    meaning = json['meaning'];
    contentAr = json['content_ar'];
    ibrahimWalk = json['ibrahim_walk'];
    abdulbasitMurattal = json['abdulbasit_murattal'];
    basfar = json['basfar'];
    assudais = json['assudais'];
    alafasy = json['alafasy'];
    algamdi = json['algamdi'];
    alshatri = json['alshatri'];
    alhudhaify = json['alhudhaify'];
    alhusary = json['alhusary'];
    arrefai = json['arrefai'];
    alakhdar = json['alakhdar'];
    almuaiqly = json['almuaiqly'];
    jebril = json['jebril'];
    minshawi = json['minshawi'];
    attablawi = json['attablawi'];
    alshuraym = json['alshuraym'];
    abdulbasit = json['abdulbasit'];
    ayyub = json['ayyub'];
    bukhatir = json['bukhatir'];
    khanUrdu = json['khan_urdu'];
    ibrahimdosary = json['ibrahimdosary'];
    jazaery = json['jazaery'];
    kabiri = json['kabiri'];
    juhayne = json['juhayne'];
    matroud = json['matroud'];
    neena = json['neena'];
    jaber = json['jaber'];
    alaqimy = json['alaqimy'];
    hajjaj = json['hajjaj'];
    baliyev = json['baliyev'];
    bosnian = json['bosnian'];
    abbad = json['abbad'];
    hussarym = json['hussarym'];
    hussaryMujawad = json['hussary_mujawad'];
    tunaji = json['tunaji'];
    qahdhani = json['qahdhani'];
    albana = json['albana'];
    alqasim = json['alqasim'];
    alqatami = json['alqatami'];
    alajamy = json['alajamy'];
    suraImages = json['sura images'];
    contentEn = json['content_en'];
    ayahImage = json['ayah_image'];
    contentEs = json['content_es'];
    contentNl = json['content_nl'];
    contentRu = json['content_ru'];
    contentSo = json['content_so'];
    contentMy = json['content_my'];
    contentZh = json['content_zh'];
    contentUz = json['content_uz'];
    contentUr = json['content_ur'];
    contentUg = json['content_ug'];
    contentTt = json['content_tt'];
    contentTr = json['content_tr'];
    contentTg = json['content_tg'];
    contentSv = json['content_sv'];
    contentSq = json['content_sq'];
    contentPt = json['content_pt'];
    contentJa = json['content_ja'];
    contentIt = json['content_it'];
    contentId = json['content_id'];
    contentHi = json['content_hi'];
    contentFr = json['content_fr'];
    contentFa = json['content_fa'];
    contentDe = json['content_de'];
    contentAz = json['content_az'];
    contentArj = json['content_arj'];
    contentAm = json['content_am'];
    contentEnSi = json['content_en_si'];
    contentSw = json['content_sw'];
    contentEnTr = json['content_en_tr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ayah-title'] = this.ayahTitle;
    data['ayahid'] = this.ayahid;
    data['Ayah_number'] = this.ayahNumber;
    data['page-tag'] = this.pageTag;
    data['pageid'] = this.pageid;
    data['rubu-tag'] = this.rubuTag;
    data['rubuhizbid'] = this.rubuhizbid;
    data['hizb-tag'] = this.hizbTag;
    data['hizbid'] = this.hizbid;
    data['juz-tag'] = this.juzTag;
    data['juzid'] = this.juzid;
    data['sura name'] = this.suraName;
    data['Sura-tag'] = this.suraTag;
    data['chapter_number'] = this.chapterNumber;
    data['meaning'] = this.meaning;
    data['content_ar'] = this.contentAr;
    data['ibrahim_walk'] = this.ibrahimWalk;
    data['abdulbasit_murattal'] = this.abdulbasitMurattal;
    data['basfar'] = this.basfar;
    data['assudais'] = this.assudais;
    data['alafasy'] = this.alafasy;
    data['algamdi'] = this.algamdi;
    data['alshatri'] = this.alshatri;
    data['alhudhaify'] = this.alhudhaify;
    data['alhusary'] = this.alhusary;
    data['arrefai'] = this.arrefai;
    data['alakhdar'] = this.alakhdar;
    data['almuaiqly'] = this.almuaiqly;
    data['jebril'] = this.jebril;
    data['minshawi'] = this.minshawi;
    data['attablawi'] = this.attablawi;
    data['alshuraym'] = this.alshuraym;
    data['abdulbasit'] = this.abdulbasit;
    data['ayyub'] = this.ayyub;
    data['bukhatir'] = this.bukhatir;
    data['khan_urdu'] = this.khanUrdu;
    data['ibrahimdosary'] = this.ibrahimdosary;
    data['jazaery'] = this.jazaery;
    data['kabiri'] = this.kabiri;
    data['juhayne'] = this.juhayne;
    data['matroud'] = this.matroud;
    data['neena'] = this.neena;
    data['jaber'] = this.jaber;
    data['alaqimy'] = this.alaqimy;
    data['hajjaj'] = this.hajjaj;
    data['baliyev'] = this.baliyev;
    data['bosnian'] = this.bosnian;
    data['abbad'] = this.abbad;
    data['hussarym'] = this.hussarym;
    data['hussary_mujawad'] = this.hussaryMujawad;
    data['tunaji'] = this.tunaji;
    data['qahdhani'] = this.qahdhani;
    data['albana'] = this.albana;
    data['alqasim'] = this.alqasim;
    data['alqatami'] = this.alqatami;
    data['alajamy'] = this.alajamy;
    data['sura images'] = this.suraImages;
    data['content_en'] = this.contentEn;
    data['ayah_image'] = this.ayahImage;
    data['content_es'] = this.contentEs;
    data['content_nl'] = this.contentNl;
    data['content_ru'] = this.contentRu;
    data['content_so'] = this.contentSo;
    data['content_my'] = this.contentMy;
    data['content_zh'] = this.contentZh;
    data['content_uz'] = this.contentUz;
    data['content_ur'] = this.contentUr;
    data['content_ug'] = this.contentUg;
    data['content_tt'] = this.contentTt;
    data['content_tr'] = this.contentTr;
    data['content_tg'] = this.contentTg;
    data['content_sv'] = this.contentSv;
    data['content_sq'] = this.contentSq;
    data['content_pt'] = this.contentPt;
    data['content_ja'] = this.contentJa;
    data['content_it'] = this.contentIt;
    data['content_id'] = this.contentId;
    data['content_hi'] = this.contentHi;
    data['content_fr'] = this.contentFr;
    data['content_fa'] = this.contentFa;
    data['content_de'] = this.contentDe;
    data['content_az'] = this.contentAz;
    data['content_arj'] = this.contentArj;
    data['content_am'] = this.contentAm;
    data['content_en_si'] = this.contentEnSi;
    data['content_sw'] = this.contentSw;
    data['content_en_tr'] = this.contentEnTr;
    return data;
  }
}
