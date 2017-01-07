"use strict"

angular.module("frontApp")
  .factory 'Const', ->
    API:
      POST:         '/api/posts'
      POST_LIST:    '/api/post_list'
      POST_DETSIL:  '/api/post_details'
      POSTS_SHOPS:  '/api/posts_shops'
      POSTS_RELATED:'/api/posts_related'
      PEOPLE_POSTS: '/api/people_posts'
      PERSON_LIST:  '/api/person_list'
      SHOP:         '/api/shops'
      SHOP_LIST:    '/api/shop_list'
      MAP:          '/api/map'
      FEATURE:      '/api/features'
      PERSON:       '/api/people'
      CATEGORY:     '/api/categories'
      PERIOD:       '/api/periods'
      USER:         '/api/users'
      LOGIN:        '/users/sign_in.json'
      FACEBOOK:     '/api/sns/facebook'
      LOGOUT:       '/authentication_token.json'
      SETTING:
        PER: 10
    CATEGORY:
      EPISODE :1
      COOKING :2
    METHOD:
      POST: 'POST'
      PATCH: 'PATCH'
    MAP:
      ZOOM:
        MIN: 9
        DEFAULT:13
      CENTER:
        DEFAULT:
          LAT: 35.6813818
          LNG: 139.7660838
      METER_PER_PX: 238.09524
      LAT_PER_METER: 0.00000901337
      LNG_PER_METER: 0.0000109664

    ADS:
      AD300X250: [
        '<a href="http://px.a8.net/svt/ejp?a8mat=2NIL4X+76ZKXE+3F7U+BYT9D" target="_blank"><img border="0" width="300" height="250" alt="" src="http://www21.a8.net/svt/bgt?aid=160430721435&wid=001&eno=01&mid=s00000015969002010000&mc=1"></a><img border="0" width="1" height="1" src="http://www14.a8.net/0.gif?a8mat=2NIL4X+76ZKXE+3F7U+BYT9D" alt="">'
        '<a href="http://px.a8.net/svt/ejp?a8mat=2NIL4X+7QMVW2+2UQW+631SX" target="_blank"><img border="0" width="300" height="250" alt="" src="http://www28.a8.net/svt/bgt?aid=160430721468&wid=001&eno=01&mid=s00000013316001022000&mc=1"></a><img border="0" width="1" height="1" src="http://www12.a8.net/0.gif?a8mat=2NIL4X+7QMVW2+2UQW+631SX" alt="">'
        '<a href="http://px.a8.net/svt/ejp?a8mat=2NIL4X+BAN2YA+2RPQ+TTLOX" target="_blank"><img border="0" width="300" height="250" alt="" src="http://www24.a8.net/svt/bgt?aid=160430721683&wid=001&eno=01&mid=s00000012923005009000&mc=1"></a><img border="0" width="1" height="1" src="http://www15.a8.net/0.gif?a8mat=2NIL4X+BAN2YA+2RPQ+TTLOX" alt="">'
        '<a href="http://px.a8.net/svt/ejp?a8mat=2NIL4X+DE94S2+3C78+60H7L" target="_blank"><img border="0" width="300" height="250" alt="" src="http://www26.a8.net/svt/bgt?aid=160430721810&wid=001&eno=01&mid=s00000015578001010000&mc=1"></a><img border="0" width="1" height="1" src="http://www18.a8.net/0.gif?a8mat=2NIL4X+DE94S2+3C78+60H7L" alt="">'
        '<a href="http://px.a8.net/svt/ejp?a8mat=2NIL4X+DXWFQQ+2Q7A+BZ8OX" target="_blank"><img border="0" width="300" height="250" alt="" src="http://www21.a8.net/svt/bgt?aid=160430721843&wid=001&eno=01&mid=s00000012727002012000&mc=1"></a><img border="0" width="1" height="1" src="http://www14.a8.net/0.gif?a8mat=2NIL4X+DXWFQQ+2Q7A+BZ8OX" alt="">'
        '<a href="http://px.a8.net/svt/ejp?a8mat=2NIL4X+DXB04Y+2Q7A+60H7L" target="_blank"><img border="0" width="300" height="250" alt="" src="http://www28.a8.net/svt/bgt?aid=160430721842&wid=001&eno=01&mid=s00000012727001010000&mc=1"></a><img border="0" width="1" height="1" src="http://www19.a8.net/0.gif?a8mat=2NIL4X+DXB04Y+2Q7A+60H7L" alt="">'
        '<a href="http://px.a8.net/svt/ejp?a8mat=2NIL4X+DH8ASY+2UCG+O0MJL" target="_blank"><img border="0" width="300" height="250" alt="" src="http://www29.a8.net/svt/bgt?aid=160430721815&wid=001&eno=01&mid=s00000013264004034000&mc=1"></a><img border="0" width="1" height="1" src="http://www14.a8.net/0.gif?a8mat=2NIL4X+DH8ASY+2UCG+O0MJL" alt="">'
        '<a href="http://px.a8.net/svt/ejp?a8mat=2NIL4X+7PG0OI+2X46+626XT" target="_blank"><img border="0" width="300" height="250" alt="" src="http://www21.a8.net/svt/bgt?aid=160430721466&wid=001&eno=01&mid=s00000013623001018000&mc=1"></a><img border="0" width="1" height="1" src="http://www14.a8.net/0.gif?a8mat=2NIL4X+7PG0OI+2X46+626XT" alt="">'
        '<a href="http://px.a8.net/svt/ejp?a8mat=2NIL4X+5MFEGI+3RK+2TZJXD" target="_blank"><img border="0" width="300" height="250" alt="" src="http://www28.a8.net/svt/bgt?aid=160430721340&wid=001&eno=01&mid=s00000000488017130000&mc=1"></a><img border="0" width="1" height="1" src="http://www12.a8.net/0.gif?a8mat=2NIL4X+5MFEGI+3RK+2TZJXD" alt="">'
        '<a href="http://px.a8.net/svt/ejp?a8mat=2NIL4X+BET46Q+2NPK+699KH" target="_blank"><img border="0" width="250" height="250" alt="" src="http://www21.a8.net/svt/bgt?aid=160430721690&wid=001&eno=01&mid=s00000012404001051000&mc=1"></a><img border="0" width="1" height="1" src="http://www12.a8.net/0.gif?a8mat=2NIL4X+BET46Q+2NPK+699KH" alt="">'
        '<a href="http://px.a8.net/svt/ejp?a8mat=2NIL4X+7R8BHU+1XGK+64CB9T" target="_blank"><img border="0" width="300" height="250" alt="" src="http://www27.a8.net/svt/bgt?aid=160430721469&wid=001&eno=01&mid=s00000009002037009000&mc=1"></a><img border="0" width="1" height="1" src="http://www15.a8.net/0.gif?a8mat=2NIL4X+7R8BHU+1XGK+64CB9T" alt="">'
        '<a href="http://px.a8.net/svt/ejp?a8mat=2NIL4X+7PG0OI+2X46+60WN5" target="_blank"><img border="0" width="300" height="250" alt="" src="http://www22.a8.net/svt/bgt?aid=160430721466&wid=001&eno=01&mid=s00000013623001012000&mc=1"></a><img border="0" width="1" height="1" src="http://www15.a8.net/0.gif?a8mat=2NIL4X+7PG0OI+2X46+60WN5" alt="">'
        '<a href="http://px.a8.net/svt/ejp?a8mat=2NIL4X+5FVMSY+1OK+6F1WH" target="_blank"><img border="0" width="300" height="250" alt="" src="http://www25.a8.net/svt/bgt?aid=160430721329&wid=001&eno=01&mid=s00000000218001078000&mc=1"></a><img border="0" width="1" height="1" src="http://www11.a8.net/0.gif?a8mat=2NIL4X+5FVMSY+1OK+6F1WH" alt="">'
        '<a href="http://px.a8.net/svt/ejp?a8mat=2NIL4X+5E3BZM+1OK+NUU7L" target="_blank"><img border="0" width="250" height="250" alt="" src="http://www22.a8.net/svt/bgt?aid=160430721326&wid=001&eno=01&mid=s00000000218004007000&mc=1"></a><img border="0" width="1" height="1" src="http://www12.a8.net/0.gif?a8mat=2NIL4X+5E3BZM+1OK+NUU7L" alt="">'
      ]
      AD468X60: [
        '<a href="http://px.a8.net/svt/ejp?a8mat=2NIL4X+76ZKXE+3F7U+BXQOH" target="_blank"><img border="0" width="468" height="60" alt="" src="http://www21.a8.net/svt/bgt?aid=160430721435&wid=001&eno=01&mid=s00000015969002005000&mc=1"></a><img border="0" width="1" height="1" src="http://www15.a8.net/0.gif?a8mat=2NIL4X+76ZKXE+3F7U+BXQOH" alt="">'
        '<a href="http://px.a8.net/svt/ejp?a8mat=2NIL4X+7QMVW2+2UQW+63OY9" target="_blank"><img border="0" width="468" height="60" alt="" src="http://www24.a8.net/svt/bgt?aid=160430721468&wid=001&eno=01&mid=s00000013316001025000&mc=1"></a><img border="0" width="1" height="1" src="http://www16.a8.net/0.gif?a8mat=2NIL4X+7QMVW2+2UQW+63OY9" alt="">'
        '<a href="http://px.a8.net/svt/ejp?a8mat=2NIL4X+BAN2YA+2RPQ+TVQUP" target="_blank"><img border="0" width="468" height="60" alt="" src="http://www20.a8.net/svt/bgt?aid=160430721683&wid=001&eno=01&mid=s00000012923005019000&mc=1"></a><img border="0" width="1" height="1" src="http://www13.a8.net/0.gif?a8mat=2NIL4X+BAN2YA+2RPQ+TVQUP" alt="">'
        '<a href="http://px.a8.net/svt/ejp?a8mat=2NIL4X+DE94S2+3C78+60OXD" target="_blank"><img border="0" width="468" height="60" alt="" src="http://www29.a8.net/svt/bgt?aid=160430721810&wid=001&eno=01&mid=s00000015578001011000&mc=1"></a><img border="0" width="1" height="1" src="http://www15.a8.net/0.gif?a8mat=2NIL4X+DE94S2+3C78+60OXD" alt="">'
        '<a href="http://px.a8.net/svt/ejp?a8mat=2NIL4X+DXWFQQ+2Q7A+BZO4H" target="_blank"><img border="0" width="468" height="60" alt="" src="http://www22.a8.net/svt/bgt?aid=160430721843&wid=001&eno=01&mid=s00000012727002014000&mc=1"></a><img border="0" width="1" height="1" src="http://www17.a8.net/0.gif?a8mat=2NIL4X+DXWFQQ+2Q7A+BZO4H" alt="">'
        '<a href="http://px.a8.net/svt/ejp?a8mat=2NIL4X+DXB04Y+2Q7A+60WN5" target="_blank"><img border="0" width="468" height="60" alt="" src="http://www27.a8.net/svt/bgt?aid=160430721842&wid=001&eno=01&mid=s00000012727001012000&mc=1"></a><img border="0" width="1" height="1" src="http://www12.a8.net/0.gif?a8mat=2NIL4X+DXB04Y+2Q7A+60WN5" alt="">'
        '<a href="http://px.a8.net/svt/ejp?a8mat=2NIL4X+DH8ASY+2UCG+NTRMP" target="_blank"><img border="0" width="468" height="60" alt="" src="http://www28.a8.net/svt/bgt?aid=160430721815&wid=001&eno=01&mid=s00000013264004002000&mc=1"></a><img border="0" width="1" height="1" src="http://www14.a8.net/0.gif?a8mat=2NIL4X+DH8ASY+2UCG+NTRMP" alt="">'
        '<a href="http://px.a8.net/svt/ejp?a8mat=2NIL4X+7PG0OI+2X46+5Z6WX" target="_blank"><img border="0" width="468" height="60" alt="" src="http://www27.a8.net/svt/bgt?aid=160430721466&wid=001&eno=01&mid=s00000013623001004000&mc=1"></a><img border="0" width="1" height="1" src="http://www14.a8.net/0.gif?a8mat=2NIL4X+7PG0OI+2X46+5Z6WX" alt="">'
        '<a href="http://px.a8.net/svt/ejp?a8mat=2NIL4X+5MFEGI+3RK+2TZRN5" target="_blank"><img border="0" width="468" height="60" alt="" src="http://www23.a8.net/svt/bgt?aid=160430721340&wid=001&eno=01&mid=s00000000488017131000&mc=1"></a><img border="0" width="1" height="1" src="http://www15.a8.net/0.gif?a8mat=2NIL4X+5MFEGI+3RK+2TZRN5" alt="">'
        '<a href="http://px.a8.net/svt/ejp?a8mat=2NIL4X+BET46Q+2NPK+669JL" target="_blank"><img border="0" width="468" height="60" alt="" src="http://www23.a8.net/svt/bgt?aid=160430721690&wid=001&eno=01&mid=s00000012404001037000&mc=1"></a><img border="0" width="1" height="1" src="http://www18.a8.net/0.gif?a8mat=2NIL4X+BET46Q+2NPK+669JL" alt="">'
        '<a href="http://px.a8.net/svt/ejp?a8mat=2NIL4X+7R8BHU+1XGK+64B0Z5" target="_blank"><img border="0" width="468" height="60" alt="" src="http://www22.a8.net/svt/bgt?aid=160430721469&wid=001&eno=01&mid=s00000009002037003000&mc=1"></a><img border="0" width="1" height="1" src="http://www12.a8.net/0.gif?a8mat=2NIL4X+7R8BHU+1XGK+64B0Z5" alt="">'
        '<a href="http://px.a8.net/svt/ejp?a8mat=2NIL4X+7PG0OI+2X46+65U41" target="_blank"><img border="0" width="468" height="60" alt="" src="http://www27.a8.net/svt/bgt?aid=160430721466&wid=001&eno=01&mid=s00000013623001035000&mc=1"></a><img border="0" width="1" height="1" src="http://www17.a8.net/0.gif?a8mat=2NIL4X+7PG0OI+2X46+65U41" alt="">'
        '<a href="http://px.a8.net/svt/ejp?a8mat=2NIL4X+5FVMSY+1OK+60WN5" target="_blank"><img border="0" width="468" height="60" alt="" src="http://www23.a8.net/svt/bgt?aid=160430721329&wid=001&eno=01&mid=s00000000218001012000&mc=1"></a><img border="0" width="1" height="1" src="http://www18.a8.net/0.gif?a8mat=2NIL4X+5FVMSY+1OK+60WN5" alt="">'
        '<a href="http://px.a8.net/svt/ejp?a8mat=2NIL4X+5E3BZM+1OK+O8ZGX" target="_blank"><img border="0" width="468" height="60" alt="" src="http://www22.a8.net/svt/bgt?aid=160430721326&wid=001&eno=01&mid=s00000000218004073000&mc=1"></a><img border="0" width="1" height="1" src="http://www14.a8.net/0.gif?a8mat=2NIL4X+5E3BZM+1OK+O8ZGX" alt="">'
      ]
      AD125X125: [
        '<a href="http://px.a8.net/svt/ejp?a8mat=2NIL4X+76ZKXE+3F7U+BZVU9" target="_blank"><img border="0" width="125" height="125" alt="" src="http://www24.a8.net/svt/bgt?aid=160430721435&wid=001&eno=01&mid=s00000015969002015000&mc=1"></a><img border="0" width="1" height="1" src="http://www16.a8.net/0.gif?a8mat=2NIL4X+76ZKXE+3F7U+BZVU9" alt="">'
        '<a href="http://px.a8.net/svt/ejp?a8mat=2NIL4X+7QMVW2+2UQW+62ENL" target="_blank"><img border="0" width="125" height="125" alt="" src="http://www29.a8.net/svt/bgt?aid=160430721468&wid=001&eno=01&mid=s00000013316001019000&mc=1"></a><img border="0" width="1" height="1" src="http://www13.a8.net/0.gif?a8mat=2NIL4X+7QMVW2+2UQW+62ENL" alt="">'
        '<a href="http://px.a8.net/svt/ejp?a8mat=2NIL4X+BAN2YA+2RPQ+U43S1" target="_blank"><img border="0" width="125" height="125" alt="" src="http://www21.a8.net/svt/bgt?aid=160430721683&wid=001&eno=01&mid=s00000012923005058000&mc=1"></a><img border="0" width="1" height="1" src="http://www13.a8.net/0.gif?a8mat=2NIL4X+BAN2YA+2RPQ+U43S1" alt="">'
        '<a href="http://px.a8.net/svt/ejp?a8mat=2NIL4X+DE94S2+3C78+609HT" target="_blank"><img border="0" width="125" height="125" alt="" src="http://www20.a8.net/svt/bgt?aid=160430721810&wid=001&eno=01&mid=s00000015578001009000&mc=1"></a><img border="0" width="1" height="1" src="http://www17.a8.net/0.gif?a8mat=2NIL4X+DE94S2+3C78+609HT" alt="">'
        '<a href="http://px.a8.net/svt/ejp?a8mat=2NIL4X+DXWFQQ+2Q7A+BYLJL" target="_blank"><img border="0" width="125" height="125" alt="" src="http://www22.a8.net/svt/bgt?aid=160430721843&wid=001&eno=01&mid=s00000012727002009000&mc=1"></a><img border="0" width="1" height="1" src="http://www16.a8.net/0.gif?a8mat=2NIL4X+DXWFQQ+2Q7A+BYLJL" alt="">'
        '<a href="http://px.a8.net/svt/ejp?a8mat=2NIL4X+DXB04Y+2Q7A+601S1" target="_blank"><img border="0" width="125" height="125" alt="" src="http://www29.a8.net/svt/bgt?aid=160430721842&wid=001&eno=01&mid=s00000012727001008000&mc=1"></a><img border="0" width="1" height="1" src="http://www15.a8.net/0.gif?a8mat=2NIL4X+DXB04Y+2Q7A+601S1" alt="">'
        '<a href="http://px.a8.net/svt/ejp?a8mat=2NIL4X+DH8ASY+2UCG+NXESX" target="_blank"><img border="0" width="125" height="125" alt="" src="http://www22.a8.net/svt/bgt?aid=160430721815&wid=001&eno=01&mid=s00000013264004019000&mc=1"></a><img border="0" width="1" height="1" src="http://www18.a8.net/0.gif?a8mat=2NIL4X+DH8ASY+2UCG+NXESX" alt="">'
        '<a href="http://px.a8.net/svt/ejp?a8mat=2NIL4X+7PG0OI+2X46+62ENL" target="_blank"><img border="0" width="125" height="125" alt="" src="http://www21.a8.net/svt/bgt?aid=160430721466&wid=001&eno=01&mid=s00000013623001019000&mc=1"></a><img border="0" width="1" height="1" src="http://www18.a8.net/0.gif?a8mat=2NIL4X+7PG0OI+2X46+62ENL" alt="">'
        '<a href="http://px.a8.net/svt/ejp?a8mat=2NIL4X+5MFEGI+3RK+2TYP29" target="_blank"><img border="0" width="125" height="125" alt="" src="http://www25.a8.net/svt/bgt?aid=160430721340&wid=001&eno=01&mid=s00000000488017126000&mc=1"></a><img border="0" width="1" height="1" src="http://www14.a8.net/0.gif?a8mat=2NIL4X+5MFEGI+3RK+2TYP29" alt="">'
        '<a href="http://px.a8.net/svt/ejp?a8mat=2NIL4X+BET46Q+2NPK+639IP" target="_blank"><img border="0" width="125" height="125" alt="" src="http://www22.a8.net/svt/bgt?aid=160430721690&wid=001&eno=01&mid=s00000012404001023000&mc=1"></a><img border="0" width="1" height="1" src="http://www11.a8.net/0.gif?a8mat=2NIL4X+BET46Q+2NPK+639IP" alt="">'
        '<a href="http://px.a8.net/svt/ejp?a8mat=2NIL4X+7R8BHU+1XGK+64DDUP" target="_blank"><img border="0" width="125" height="125" alt="" src="http://www20.a8.net/svt/bgt?aid=160430721469&wid=001&eno=01&mid=s00000009002037014000&mc=1"></a><img border="0" width="1" height="1" src="http://www12.a8.net/0.gif?a8mat=2NIL4X+7R8BHU+1XGK+64DDUP" alt="">'
        '<a href="http://px.a8.net/svt/ejp?a8mat=2NIL4X+7PG0OI+2X46+62ENL" target="_blank"><img border="0" width="125" height="125" alt="" src="http://www24.a8.net/svt/bgt?aid=160430721466&wid=001&eno=01&mid=s00000013623001019000&mc=1"></a><img border="0" width="1" height="1" src="http://www10.a8.net/0.gif?a8mat=2NIL4X+7PG0OI+2X46+62ENL" alt="">'
        '<a href="http://px.a8.net/svt/ejp?a8mat=2NIL4X+5FVMSY+1OK+631SX" target="_blank"><img border="0" width="125" height="125" alt="" src="http://www26.a8.net/svt/bgt?aid=160430721329&wid=001&eno=01&mid=s00000000218001022000&mc=1"></a><img border="0" width="1" height="1" src="http://www15.a8.net/0.gif?a8mat=2NIL4X+5FVMSY+1OK+631SX" alt="">'
        '<a href="http://px.a8.net/svt/ejp?a8mat=2NIL4X+5E3BZM+1OK+O54KX" target="_blank"><img border="0" width="120" height="120" alt="" src="http://www23.a8.net/svt/bgt?aid=160430721326&wid=001&eno=01&mid=s00000000218004055000&mc=1"></a><img border="0" width="1" height="1" src="http://www10.a8.net/0.gif?a8mat=2NIL4X+5E3BZM+1OK+O54KX" alt="">'
      ]
