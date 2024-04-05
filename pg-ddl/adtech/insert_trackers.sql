INSERT INTO adtech.categories (id, name) VALUES
(1, 'Ad Network'),
(2, 'Mobile Attribution'),
(3, 'Analytics');


INSERT INTO adtech.companies (id, "name", parent_company_id) VALUES
(1, 'Google', NULL),
(2, 'Facebook', NULL),
(3, 'AppsFlyer', NULL),
(4, 'AppLovin', NULL),
(5, 'Kochava', NULL),
(6, 'Unity Ads', NULL),
(7, 'IAB Open Measurement', NULL),
(8, 'Tenjin', NULL),
(9, 'AirBridge', NULL),
(10, 'No Trackers Found', NULL),
(11, 'WanMei 完美', NULL),
(12, 'Branch', NULL),
(13, 'Salesforce', NULL),
(14, 'Singular', NULL),
(15, 'GameAnalytics', NULL),
(16, 'Ogury', NULL),
(17, 'Airship', NULL),
(18, 'InMarket', NULL),
(19, 'SFBX', NULL),
(20, 'Digital Turbine', NULL),
(21, 'InMobi', NULL),
(23, 'Amazon Advertisement', NULL),
(24, 'One Signal', NULL),
(27, 'Flurry', 52),
(28, 'ByteDance', NULL),
(29, 'Mintegral', NULL),
(30, 'ChartBoost', NULL),
(31, 'Fyber', NULL),
(32, 'VK', NULL),
(33, 'AdJoe', 76),
(34, 'BIGO Ads', 53),
(35, 'Tempo Platform', NULL),
(36, 'VOODOO', NULL),
(37, 'Smaato', 54),
(38, 'Appodeal', NULL),
(39, 'LiftOff', NULL),
(40, 'PubNative', 54),
(42, 'AyeT Studios', NULL),
(43, 'Super Awesome', NULL),
(44, 'Kidoz', NULL),
(45, 'Yandex', NULL),
(25, 'TapJoy', 6),
(56, 'AdColony', 20),
(41, 'BidMachine', 38),
(46, 'AdMob', 1),
(47, 'ironSource', 6),
(48, 'Firebase', 1),
(49, 'Adjust', 4),
(50, 'Google Analytics', 1),
(51, 'AerServ', 21),
(22, 'Vungle', 39),
(52, 'Yahoo!', NULL),
(53, 'Joyy', NULL),
(54, 'Verve Group', NULL),
(55, 'Admost', NULL),
(57, 'Yabbi', NULL),
(58, 'Yandex Metrica', 45),
(59, 'Huawei', NULL),
(60, 'Huawei Analytics', 59),
(61, 'Criteo', NULL),
(62, 'MobileFuse', NULL),
(63, 'PubMatic', NULL),
(64, 'Display.io', NULL),
(65, 'Adswizz', NULL),
(71, 'Prodege', NULL),
(66, 'Bitlabs.ai', 71),
(67, 'Verizon Ads', NULL),
(68, 'myTarget', 32),
(69, 'Braze', NULL),
(70, 'Start.io', NULL),
(72, 'CleverTap', NULL),
(73, 'UseButton', NULL),
(74, 'Medallia Sense360', NULL),
(75, 'Gimbal', NULL),
(76, 'AppLike', NULL),
(77, 'JustTrack', 76),
(78, 'LeanPlum', 72),
(79, 'LiveRamp', NULL),
(80, 'Dynata', NULL),
(81, 'InBrain', 80),
(82, 'RenRen', NULL),
(83, 'Didomi', NULL),
(84, 'Amplitude', NULL),
(85, 'Mixpanel', NULL),
(86, 'Mopub', 4, NULL),
(87, 'Sentry.io', NULL),
(88, 'RevenueCat', NULL),
(89, 'Aarki', NULL),
(90, 'Adikteev', NULL),
(91, 'Adkomo', NULL),
(92, 'Adtiming', NULL),
(93, 'Adzmedia', NULL),
(94, 'Appier', NULL),
(95, 'Applift', NULL),
(96, 'Appreciate', NULL),
(98, 'Apptimus LTD', NULL),
(99, 'Arpeely', NULL),
(100, 'Beeswax', NULL),
(101, 'Centro', NULL),
(102, 'CurateMobile', NULL),
(103, 'Dataseat', NULL),
(104, 'Discipline Digital', NULL),
(105, 'FeedMob', NULL),
(106, 'GlobalWide', NULL),
(107, 'Hybrid', NULL),
(108, 'Jampp', NULL),
(109, 'Kayzen', NULL),
(110, 'Lifestreet', NULL),
(111, 'Loopme', NULL),
(112, 'Maiden Marketing', NULL),
(113, 'Mobrand', NULL),
(114, 'Mobupps', NULL),
(115, 'Moloco', NULL),
(116, 'MYAPPFREE S.P.A.', NULL),
(117, 'Opera', NULL),
(118, 'Persona.ly', NULL),
(119, 'Qverse', NULL),
(120, 'Remerge', NULL),
(121, 'RTB House', NULL),
(122, 'Sabio Mobile Inc.', NULL),
(123, 'ScaleMonk', NULL),
(124, 'Sift', NULL),
(125, 'Smadex', NULL),
(126, 'Snap Inc.', NULL),
(127, 'Spyke Media', NULL),
(128, 'Tremor', NULL),
(129, 'YouAppi', NULL),
(130, 'New Relic', NULL),
(131, 'Qualtrics', NULL),
(132, 'Nimbus', NULL);



INSERT INTO adtech.company_categories (company_id, category_id) VALUES
(1, 1),
(2, 1),
(3, 2),
(4, 1),
(5, 2),
(6, 1),
(7, 3),
(8, 2),
(9, 2),
(10, 1),
(11, 1),
(12, 2),
(13, 3),
(14, 3),
(15, 3),
(16, 1),
(17, 1),
(18, 1),
(19, 1),
(20, 1),
(21, 1),
(22, 1),
(23, 1),
(24, 1),
(25, 1),
(27, 1),
(28, 1),
(29, 1),
(30, 1),
(31, 1),
(32, 1),
(33, 1),
(34, 1),
(35, 1),
(36, 1),
(37, 1),
(38, 1),
(39, 1),
(40, 1),
(41, 1),
(42, 1),
(43, 1),
(44, 1),
(45, 1),
(46, 1),
(47, 1),
(48, 3),
(49, 2),
(50, 3),
(51, 1),
(52, 1),
(53, 1),
(54, 1),
(55, 1),
(56, 1),
(57, 1),
(58, 2),
(59, 1),
(60, 2),
(61, 1),
(62, 1),
(63, 1),
(64, 1),
(65, 1),
(66, 1),
(67, 1),
(69, 2),
(70, 1),
(71, 1),
(72, 2),
(73, 2),
(74, 2),
(75, 2),
(76, 1),
(77, 2),
(78, 2),
(79, 2),
(80, 2),
(86, 1),
(87, 2),
(88, 2),
(89, 1),
(90, 1),
(91, 1),
(92, 1),
(93, 1),
(94, 1),
(95, 1),
(96, 1),
(98, 1),
(99, 1),
(100, 1),
(101, 1),
(102, 1),
(103, 1),
(104, 1),
(105, 1),
(106, 1),
(107, 1),
(108, 1),
(109, 1),
(110, 1),
(111, 1),
(112, 1),
(113, 1),
(114, 1),
(115, 1),
(116, 1),
(117, 1),
(118, 1),
(119, 1),
(120, 1),
(121, 1),
(122, 1),
(123, 1),
(124, 1),
(125, 1),
(126, 1),
(127, 1),
(128, 1),
(129, 1),
(130, 2),
(131, 2),
(132, 1);



INSERT INTO adtech.sdk_packages (company_id, package_pattern) VALUES
(48, 'com.google.firebase.analytics'),
(1, 'com.google.android.gms.measurement'),
(48, 'com.google.firebase.firebase_analytics'),
(3, 'com.appsflyer'),
(5, 'com.kochava'),
(49, 'com.adjust.sdk'),
(49, 'com.adjust.android.sdk'),
(2, 'com.facebook.appevents'),
(2, 'com.facebook.marketing'),
(2, 'com.facebook.CampaignTrackingReceiver'),
(2, 'com.facebook.sdk.ApplicationId'),
(2, 'com.facebook.ads'),
(12, 'io.branch.sdk'),
(13, 'com.salesforce.marketingcloud'),
(15, 'com.gameanalytics.sdk'),
(17, 'com.urbanairship'),
(18, 'com.inmarket.m2m'),
(19, 'com.sfbx.appconsentv3'),
(50, 'com.google.android.apps.analytics'),
(50, 'com.google.android.gms.analytics'),
(50, 'com.google.analytics'),
(7, 'com.iab.omid.library'),
(7, 'com.prime31.util.IabHelperImpl'),
(7, 'com.prime31.IAB'),
(8, 'com.tenjin.android'),
(9, 'io.airbridge'),
(11, 'com.wpsdk'),
(48, 'com.google.firebase'),
(14, 'com.singular.sdk'),
(14, 'com.singular.preinstall'),
(1, 'com.google.ads'),
(1, 'com.google.android.gms.ads'),
(1, 'com.google.android.ads'),
(1, 'com.google.unity.ads'),
(1, 'com.google.android.gms.admob'),
(1, 'com.google.firebase.firebase_ads'),
(47, 'com.ironsource'),
(6, 'com.unity3d.services'),
(6, 'com.unity3d.ads'),
(4, 'com.applovin'),
(4, 'applovin.sdk.key'),
(34, 'sg.bigo.ads.'),
(35, 'com.tempoplatform.ads'),
(36, 'io.voodoo.adn'),
(37, 'com.smaato.sdk'),
(39, 'io.liftoff.liftoffads'),
(40, 'net.pubnative'),
(41, 'io.bidmachine'),
(51, 'com.aerserv.sdk'),
(42, 'com.ayetstudios'),
(43, 'tv.superawesome.sdk'),
(44, 'com.kidoz.sdk.api'),
(45, 'com.yandex.mobile.ads'),
(16, 'com.ogury'),
(21, 'com.inmobi'),
(21, 'in.inmobi'),
(56, 'com.adcolony'),
(56, 'com.jirbo.adcolony'),
(22, 'com.vungle.publisher'),
(22, 'com.vungle.warren'),
(22, 'com.vungle.ads'),
(23, 'com.amazon.device.ads'),
(23, 'com.amazon.aps.ads'),
(24, 'com.onesignal'),
(27, 'com.flurry'),
(28, 'com.bytedance'),
(28, 'com.pgl'),
(28, 'com.pangle.global'),
(29, 'com.mintegral'),
(29, 'com.mbridge.msdk'),
(30, 'com.chartboost.sdk'),
(25, 'com.tapjoy'),
(31, 'com.fyber'),
(32, 'com.vk.sdk'),
(32, 'com.vk.api.sdk'),
(33, 'io.adjoe.sdk'),
(20, 'com.digitalturbine'),
(55, 'admost.adserver'),
(55, 'admost.sdk'),
(57, 'me.yabbi'),
(58, 'com.yandex.metrica'),
(60, 'com.huawei.hms.analytics'),
(61, 'com.criteo.publisher'),
(62, 'com.mobilefuse.sdk'),
(63, 'com.pubmatic.sdk'),
(16, 'io.presage.mraid'),
(16, 'io.presage.interstitial'),
(38, 'com.explorestack.iab'),
(64, 'com.brandio.ads'),
(65, 'com.adswizz'),
(66, 'ai.bitlabs.sdk'),
(67, 'com.verizon.ads'),
(68, 'com.my.target'),
(69, 'com.braze'),
(70, 'com.startapp'),
(33, 'io.adjoe.protection.'),
(71, 'com.prodege.internal'),
(72, 'com.clevertap'),
(73, 'com.usebutton.sdk'),
(74, 'com.sense360'),
(18, 'com.inmarket.notouch'),
(75, 'com.gimbal'),
(76, 'de.mcoins.applike'),
(77, 'io.justtrack'),
(78, 'com.leanplum'),
(84, 'com.amplitude'),
(85, 'com.mixpanel'),
(60, 'com.huawei.hms.location'),
(86, 'com.mopub'),
(87, 'io.sentry'),
(87, 'com.joshdholtz.sentry'),
(88, 'com.revenuecat');
(89,'4fzdc2evr5.skadnetwork'),
(56,'4pfyvq9l8r.skadnetwork'),
(90,'ydx93a7ass.skadnetwork'),
(91,'tmhh9296z4.skadnetwork'),
(92,'488r3q3dtq.skadnetwork'),
(93,'nzq8sh4pbs.skadnetwork'),
(94,'v72qych5uu.skadnetwork'),
(95,'6xzpu9s2p8.skadnetwork'),
(4,'ludvb6z3bs.skadnetwork'),
(96,'mlmmfzh3r3.skadnetwork'),
(98,'lr83yxwka7.skadnetwork'),
(99,'cp8zw746q7.skadnetwork'),
(100,'c6k4g5qg8m.skadnetwork'),
(41,'wg4vff78zm.skadnetwork'),
(101,'3sh42y64q3.skadnetwork'),
(30,'f38h382jlk.skadnetwork'),
(61,'hs6bdukanm.skadnetwork'),
(61,'9rd848q2bz.skadnetwork'),
(102,'52fl2v3hgk.skadnetwork'),
(103,'m8dbw4sv7c.skadnetwork'),
(104,'m5mvw97r93.skadnetwork'),
(2,'v9wttpbfk9.skadnetwork'),
(2,'n38lu8286q.skadnetwork'),
(105,'fz2k2k5tej.skadnetwork'),
(106,'g2y4y55b64.skadnetwork'),
(46,'cstr6suwn9.skadnetwork'),
(107,'w9q455wk68.skadnetwork'),
(21,'wzmmz9fp6w.skadnetwork'),
(47,'su67r6k2v3.skadnetwork'),
(108,'yclnxrl5pm.skadnetwork'),
(109,'4468km3ulz.skadnetwork'),
(44,'v79kvwwj4g.skadnetwork'),
(110,'t38b2kh725.skadnetwork'),
(39,'7ug5zh24hu.skadnetwork'),
(111,'5lm9lj6jb7.skadnetwork'),
(112,'zmvfpc5aq8.skadnetwork'),
(29,'kbd757ywx3.skadnetwork'),
(113,'ns5j362hk7.skadnetwork'),
(114,'275upjj5gd.skadnetwork'),
(115,'9t245vhmpl.skadnetwork'),
(116,'cad8qz2s3j.skadnetwork'),
(117,'a2p9lx4jpn.skadnetwork'),
(28,'238da6jt44.skadnetwork'),
(28,'22mmun2rn5.skadnetwork'),
(118,'44jx6755aq.skadnetwork'),
(40,'tl55sbb4fm.skadnetwork'),
(119,'24zw6aqk47.skadnetwork'),
(120,'2u9pt9hc89.skadnetwork'),
(121,'8s468mfl3y.skadnetwork'),
(122,'glqzh8vgby.skadnetwork'),
(123,'av6w8kgt66.skadnetwork'),
(124,'klf5c3l5u5.skadnetwork'),
(125,'ppxm28t8ap.skadnetwork'),
(126,'424m5254lk.skadnetwork'),
(127,'44n7hlldy6.skadnetwork'),
(25,'ecpz2srf59.skadnetwork'),
(128,'pwa73g5rt2.skadnetwork'),
(6,'4dzt52r2t5.skadnetwork'),
(6,'bvpn9ufa9b.skadnetwork'),
(22,'gta9lk7p23.skadnetwork'),
(129,'3rd42ekr43.skadnetwork'),
(48,'GoogleUtilities.framework'),
(48, 'FirebaseCore.framework'),
(48, 'FirebaseInstallations.framework'),
(48, 'FirebaseCoreInternal.framework'),
(2,'FBAEMKit.framework'),
(2,'FBSDKLoginKit.framework'),
(2,'FBSDKCoreKit_Basics.framework'),
(20,'IASDKCore.framework'),
(38,'DTBiOSSDK.framework'),
(4,'AppLovinQualityService.framework'),
(130,'NewRelic.framework'),
(131,'Qualtrics.framework'),
(87,'Sentry.framework'),
(74,'MedalliaDigitalSDK.framework'),
(12,'BranchSDK.framework'),
(3,'AppsFlyerConversionValueV3.framework'),
(3,'AppsFlyerConversionValueV4.framework'),
(3,'AppsFlyerLib.framework'),
(49, 'Adjust.framework'),
(49, 'AdjustSigSdk.framework'),
(49, 'KochavaCore.framework'),
(49, 'KochavaTracker.framework'),
(49, 'KochavaAdNetwork.framework'),
(6, 'UnityFramework.framework'),
(1, 'GoogleInteractiveMediaAds.framework'),
(132, 'OMSDK_Adsbynimbus.framework'),
(65, 'AdswizzSDK.framework'),
(65, 'AdswizzSDKCore.framework'),
(65, 'AdswizzSDKPrivacyData.framework')
;


INSERT INTO adtech.company_developers (company_id, developer_id) VALUES
(25953, 1),
(4593191, 1);
