import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_kepuharjo_new/Dashboard_User/Screen/Setting/daftar_keluarga.dart';
import 'package:mobile_kepuharjo_new/Dashboard_User/Screen/Setting/info_aplikasi.dart';
import 'package:mobile_kepuharjo_new/Dashboard_User/Screen/Setting/informasi_akun.dart';
import 'package:mobile_kepuharjo_new/Dashboard_User/Screen/Setting/tentang_user.dart';
import 'package:mobile_kepuharjo_new/Dashboard_User/Screen/Setting/ubah_nohp.dart';
import 'package:mobile_kepuharjo_new/Dashboard_User/Screen/Status/TabBarView/surat_dibatalkan.dart';
import 'package:mobile_kepuharjo_new/Dashboard_User/dashboard_user.dart';
import 'package:mobile_kepuharjo_new/Model/User.dart';
import 'package:mobile_kepuharjo_new/Resource/Mycolor.dart';
import 'package:mobile_kepuharjo_new/Resource/Myfont.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:mobile_kepuharjo_new/Services/auth_services.dart';
import 'package:android_intent_plus/android_intent.dart';

class Pengaturan extends StatefulWidget {
  const Pengaturan({super.key});

  @override
  State<Pengaturan> createState() => _PengaturanState();
}

class _PengaturanState extends State<Pengaturan> {
  // AuthServices authServices = AuthServices();
  User? user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  Future<void> getUser() async {
    final authServices = AuthServices();
    final auth = await authServices.me();
    if (auth != null) {
      setState(() {
        user = auth;
      });
    }
  }

  final authServices = AuthServices();
  showSuccessDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.warning,
      title: 'Warning!',
      titleTextStyle: MyFont.poppins(
          fontSize: 25, color: primaryColor, fontWeight: FontWeight.bold),
      desc: 'Apakah anda yakin, untuk Keluar dari aplikasi',
      descTextStyle: MyFont.poppins(fontSize: 12, color: softgrey),
      btnOkOnPress: () {
        authServices.logout(context);
        Fluttertoast.showToast(
            msg: "Berhasil keluar dari aplikasi",
            backgroundColor: black.withOpacity(0.7));
      },
      btnCancelOnPress: () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const DashboardUser(),
            ),
            (route) => false);
      },
      btnCancelIcon: Icons.highlight_off_rounded,
      btnOkIcon: Icons.task_alt_rounded,
    ).show();
  }

  String lokasi = "kantor Kelurahan Tompokersan Kabupaten Lumajang";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: backgroundGrey,
      appBar: AppBar(
        backgroundColor: white,
        shadowColor: Colors.transparent,
        title: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Text(
            "Profil",
            style: MyFont.poppins(
                fontSize: 20, color: black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SingleChildScrollView(
        // padding: EdgeInsets.all(15),
        // physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              color: white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.all(20),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    height: 65,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(width: 1, color: softgrey)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(100)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                user?.masyarakat?.namaLengkap!
                                        .substring(0, 2)
                                        .toUpperCase() ??
                                    "",
                                style: MyFont.montserrat(
                                    fontSize: 16,
                                    color: white,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Visibility(
                              visible: user != null && user!.masyarakat != null,
                              replacement: CardLoading(
                                height: 15,
                                width: 150,
                                borderRadius: BorderRadius.circular(10),
                                // color: Colors.grey,
                              ),
                              child: Text(
                                user?.masyarakat?.namaLengkap ?? "",
                                style: MyFont.poppins(
                                  fontSize: 14,
                                  color: black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Visibility(
                              visible: user != null && user!.masyarakat != null,
                              replacement: Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: CardLoading(
                                  height: 15,
                                  width: 200,
                                  borderRadius: BorderRadius.circular(10),
                                  // color: Colors.grey,
                                ),
                              ),
                              child: Text(
                                user?.masyarakat?.nik.toString() ?? "",
                                style: MyFont.poppins(
                                  fontSize: 12,
                                  color: black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, top: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Akun",
                          textAlign: TextAlign.start,
                          style: MyFont.poppins(
                              fontSize: 14,
                              color: black,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InformasiAkun(),
                                ));
                          },
                          leading: Image.asset(
                            "images/profile.png",
                            height: 27,
                          ),
                          title: Text(
                            "Informasi Akun",
                            style: MyFont.poppins(fontSize: 12, color: black),
                          ),
                        ),
                        const Divider(
                          height: 1,
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UbahNoHp(),
                                ));
                          },
                          leading: Image.asset(
                            "images/call.png",
                            height: 25,
                          ),
                          title: Text(
                            "Ubah Nomer Telepon",
                            style: MyFont.poppins(fontSize: 12, color: black),
                          ),
                        ),
                        const Divider(
                          height: 1,
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DaftarKeluargaUser(),
                                ));
                          },
                          leading: Image.asset(
                            "images/group.png",
                            height: 27,
                          ),
                          title: Text(
                            "Daftar Keluarga",
                            style: MyFont.poppins(fontSize: 12, color: black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              padding: EdgeInsets.all(8),
              color: white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, top: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Lokasi",
                          textAlign: TextAlign.start,
                          style: MyFont.poppins(
                              fontSize: 14,
                              color: black,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ListTile(
                          onTap: () async {
                            final intent = AndroidIntent(
                                action: 'action_view',
                                data: Uri.encodeFull(
                                    'google.navigation:q=${lokasi.trim()}'),
                                package: 'com.google.android.apps.maps');
                            await intent.launch();
                          },
                          leading: Image.asset(
                            "images/maps.png",
                            height: 27,
                          ),
                          title: Text(
                            "Lokasi Kelurahan",
                            style: MyFont.poppins(fontSize: 12, color: black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              padding: EdgeInsets.all(8),
              color: white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, top: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Surat",
                          textAlign: TextAlign.start,
                          style: MyFont.poppins(
                              fontSize: 14,
                              color: black,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SuratDibatalkanUser(),
                                ));
                          },
                          leading: Image.asset(
                            "images/mail_cancel.png",
                            height: 30,
                          ),
                          title: Text(
                            "Surat Dibatalkan",
                            style: MyFont.poppins(fontSize: 12, color: black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              padding: EdgeInsets.all(8),
              color: white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, top: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Tentang",
                          textAlign: TextAlign.start,
                          style: MyFont.poppins(
                              fontSize: 14,
                              color: black,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InfoAplikasi(),
                                ));
                          },
                          leading: Image.asset(
                            "images/info.png",
                            height: 27,
                          ),
                          title: Text(
                            "Info Aplikasi",
                            style: MyFont.poppins(fontSize: 12, color: black),
                          ),
                        ),
                        const Divider(
                          height: 10,
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TentangUser(),
                                ));
                          },
                          leading: Image.asset(
                            "images/ask.png",
                            height: 27,
                          ),
                          title: Text(
                            "Tentang",
                            style: MyFont.poppins(fontSize: 12, color: black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              height: 45,
              width: MediaQuery.of(context).size.width,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: primaryColor, // Warna latar belakang
                  // side: BorderSide(width: 1, color: primaryColor), // Border
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  showSuccessDialog(context);
                },
                child: Text(
                  'Keluar',
                  style: MyFont.poppins(
                      fontSize: 14, color: white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  "S-Tompokersan\nversi 1.0.1",
                  textAlign: TextAlign.center,
                  style: MyFont.poppins(fontSize: 12, color: softgrey),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
