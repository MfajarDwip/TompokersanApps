import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_kepuharjo_new/Dashboard_User/dashboard_user.dart';
import 'package:mobile_kepuharjo_new/Model/Masyarakat.dart';
import 'package:mobile_kepuharjo_new/Model/Pengajuan.dart';
import 'package:mobile_kepuharjo_new/Model/Surat.dart';
import 'package:mobile_kepuharjo_new/Resource/MyTextField_Pengajuan.dart';
import 'package:mobile_kepuharjo_new/Resource/Mycolor.dart';
import 'package:mobile_kepuharjo_new/Resource/Myfont.dart';
import 'package:intl/intl.dart';
import 'package:mobile_kepuharjo_new/Model/Surat.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:mobile_kepuharjo_new/Services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_kepuharjo_new/Services/api_connect.dart';

class DetailSurat extends StatefulWidget {
  Masyarakat masyarakat;
  Surat surat;
  Pengajuan pengajuan;

  DetailSurat(
      {Key? key,
      required this.surat,
      required this.pengajuan,
      required this.masyarakat})
      : super(key: key);

  @override
  State<DetailSurat> createState() => _DetailSuratState();
}

class _DetailSuratState extends State<DetailSurat> {
  showSuccessDialog(BuildContext context, String id) {
    AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.warning,
      title: 'Warning!',
      titleTextStyle: MyFont.poppins(
          fontSize: 25, color: lavender, fontWeight: FontWeight.bold),
      desc: 'Apakah anda yakin, untuk membatalkan surat?',
      descTextStyle: MyFont.poppins(fontSize: 12, color: softgrey),
      btnOkOnPress: () {
        pembatalan(id);
      },
      btnCancelOnPress: () {
        Navigator.pop(context);
      },
      btnCancelIcon: Icons.highlight_off_rounded,
      btnOkIcon: Icons.task_alt_rounded,
    ).show();
  }

  ApiServices apiServices = ApiServices();
  late Future<List<Pengajuan>> listdata;

  Future pembatalan(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      var res = await http.post(Uri.parse("${Api.pembatalan}/$id"),
          headers: {"Authorization": "Bearer $token"});
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        if (data['message'] == "Surat berhasil dibatalkan") {
          Fluttertoast.showToast(
              msg: "Pengajuan surat berhasil dibatalkan",
              backgroundColor: black.withOpacity(0.7),
              toastLength: Toast.LENGTH_LONG);
          setState(() {
            listdata = apiServices.getStatus("Diajukan");
          });
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => DashboardUser(),
              ));
        } else {
          Fluttertoast.showToast(
              msg: "Gagal membatalkan surat",
              backgroundColor: Colors.red,
              toastLength: Toast.LENGTH_LONG);
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    nokk.text = widget.masyarakat.kks!.noKk.toString();
    nik.text = widget.masyarakat.nik.toString();
    nama.text = widget.masyarakat.namaLengkap.toString();
    ttl.text =
        "${widget.masyarakat.tempatLahir}, ${DateFormat('dd MMMM yyyy').format(DateTime.parse(widget.masyarakat.tglLahir.toString()))}";
    goldarah.text = widget.masyarakat.golonganDarah.toString();
    jk.text = widget.masyarakat.jenisKelamin.toString();
    kewarganegaraan.text = widget.masyarakat.kewarganegaraan.toString();
    agama.text = widget.masyarakat.agama.toString();
    statusperkawinan.text = widget.masyarakat.statusPerkawinan.toString();
    pekerjaan.text = widget.masyarakat.pekerjaan.toString();
    pendidikan.text = widget.masyarakat.pendidikan.toString();
    alamat.text = widget.masyarakat.kks!.alamat.toString();
    rt.text = widget.masyarakat.kks!.rt.toString();
    rw.text = widget.masyarakat.kks!.rw.toString();
    keperluan.text = widget.pengajuan.keterangan.toString();
    imagekk.text = widget.pengajuan.imageKk.toString();
    imagektp.text = widget.pengajuan.imageKTP.toString();
    imagebidan.text = widget.pengajuan.imageBidan.toString();
    imagesuratlahir.text = widget.pengajuan.imageSuratLahir.toString();
    imagesuratkematian.text = widget.pengajuan.imageSuratKematian.toString();
    imagesuratnikah.text = widget.pengajuan.imageSuratNikah.toString();
    imageaktacerai.text = widget.pengajuan.imageAktaCerai.toString();
    imagesuratkehilangan.text =
        widget.pengajuan.imageSuratKehilangan.toString();
    imageaktekelahiran.text = widget.pengajuan.imageAkteKelahiran.toString();
    imagesuratizin.text = widget.pengajuan.imageSuratIzin.toString();
    imagestnk.text = widget.pengajuan.imageSTNK.toString();
    imagebpkb.text = widget.pengajuan.imageBPKB.toString();
    imagesertifikat.text = widget.pengajuan.imageSertifikat.toString();
    imagesppt.text = widget.pengajuan.imageSPPT.toString();
    imagesurattanah.text = widget.pengajuan.imageSuratTanah.toString();
    listdata = apiServices.getStatus("Diajukan");
  }

  final nokk = TextEditingController();
  final nik = TextEditingController();
  final nama = TextEditingController();
  final ttl = TextEditingController();
  final goldarah = TextEditingController();
  final jk = TextEditingController();
  final kewarganegaraan = TextEditingController();
  final agama = TextEditingController();
  final statusperkawinan = TextEditingController();
  final pekerjaan = TextEditingController();
  final pendidikan = TextEditingController();
  final alamat = TextEditingController();
  final rt = TextEditingController();
  final rw = TextEditingController();
  final keperluan = TextEditingController();
  final imagekk = TextEditingController();
  final imagebukti = TextEditingController();
  final imagektp = TextEditingController();
  final imagebidan = TextEditingController();
  final imagesuratlahir = TextEditingController();
  final imagesuratkematian = TextEditingController();
  final imagesuratnikah = TextEditingController();
  final imageaktacerai = TextEditingController();
  final imagesuratkehilangan = TextEditingController();
  final imageaktekelahiran = TextEditingController();
  final imagesuratizin = TextEditingController();
  final imagestnk = TextEditingController();
  final imagebpkb = TextEditingController();
  final imagesertifikat = TextEditingController();
  final imagesppt = TextEditingController();
  final imagesurattanah = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
          backgroundColor: white,
          shadowColor: Colors.transparent,
          centerTitle: false,
          automaticallyImplyLeading: false,
          title: Text(
            "Info Surat",
            style: MyFont.poppins(
                fontSize: 14, color: black, fontWeight: FontWeight.bold),
          ),
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Icon(
                Icons.keyboard_arrow_left_rounded,
                color: black,
              ),
            ),
          )),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 20),
              child: Text(
                "Pengajuan Surat Keterangan ${widget.surat.namaSurat}",
                style: MyFont.poppins(
                    fontSize: 13, color: black, fontWeight: FontWeight.bold),
              ),
            ),
            GetTextFieldPengajuan(
                controller: nokk,
                label: "No. Kartu Keluarga",
                keyboardType: TextInputType.name,
                inputFormatters:
                    FilteringTextInputFormatter.singleLineFormatter),
            GetTextFieldPengajuan(
              controller: nik,
              label: "No. Induk Keluarga",
              keyboardType: TextInputType.name,
              inputFormatters: FilteringTextInputFormatter.singleLineFormatter,
            ),
            GetTextFieldPengajuan(
              controller: nama,
              label: "Nama Lengkap",
              keyboardType: TextInputType.name,
              inputFormatters: FilteringTextInputFormatter.singleLineFormatter,
            ),
            GetTextFieldPengajuan(
              controller: ttl,
              label: "Tempat, Tanggal Lahir",
              keyboardType: TextInputType.name,
              inputFormatters: FilteringTextInputFormatter.singleLineFormatter,
            ),
            GetTextFieldPengajuan(
              controller: goldarah,
              label: "Golongan Darah",
              keyboardType: TextInputType.name,
              inputFormatters: FilteringTextInputFormatter.singleLineFormatter,
            ),
            GetTextFieldPengajuan(
              controller: jk,
              label: "Jenis Kelamin",
              keyboardType: TextInputType.name,
              inputFormatters: FilteringTextInputFormatter.singleLineFormatter,
            ),
            GetTextFieldPengajuan(
              controller: kewarganegaraan,
              label: "Kewarganegaraan",
              keyboardType: TextInputType.name,
              inputFormatters: FilteringTextInputFormatter.singleLineFormatter,
            ),
            GetTextFieldPengajuan(
              controller: agama,
              label: "Agama",
              keyboardType: TextInputType.name,
              inputFormatters: FilteringTextInputFormatter.singleLineFormatter,
            ),
            GetTextFieldPengajuan(
              controller: statusperkawinan,
              label: "Status Perkawinan",
              keyboardType: TextInputType.name,
              inputFormatters: FilteringTextInputFormatter.singleLineFormatter,
            ),
            GetTextFieldPengajuan(
              controller: pekerjaan,
              label: "Pekerjaan",
              keyboardType: TextInputType.name,
              inputFormatters: FilteringTextInputFormatter.singleLineFormatter,
            ),
            GetTextFieldPengajuan(
              controller: pendidikan,
              label: "Pendidikan",
              keyboardType: TextInputType.name,
              inputFormatters: FilteringTextInputFormatter.singleLineFormatter,
            ),
            GetTextFieldPengajuan(
              controller: alamat,
              label: "Alamat",
              keyboardType: TextInputType.name,
              inputFormatters: FilteringTextInputFormatter.singleLineFormatter,
            ),
            GetTextFieldPengajuan(
              controller: rt,
              label: "RT",
              keyboardType: TextInputType.name,
              inputFormatters: FilteringTextInputFormatter.singleLineFormatter,
            ),
            GetTextFieldPengajuan(
              controller: rw,
              label: "RW",
              keyboardType: TextInputType.name,
              inputFormatters: FilteringTextInputFormatter.singleLineFormatter,
            ),
            GetTextFieldPengajuan(
              controller: keperluan,
              label: "Keperluan",
              keyboardType: TextInputType.name,
              inputFormatters: FilteringTextInputFormatter.singleLineFormatter,
            ),
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Image.network(
                        Api.connectimage + widget.pengajuan.imageKk!.trim(),
                      ),
                    );
                  },
                );
              },
              child: GetTextFieldPengajuan(
                controller: imagekk,
                label: "Fotokopi Kartu Keluarga",
                keyboardType: TextInputType.name,
                inputFormatters:
                    FilteringTextInputFormatter.singleLineFormatter,
              ),
            ),
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Image.network(
                        Api.connectimage + widget.pengajuan.imageKTP!.trim(),
                      ),
                    );
                  },
                );
              },
              child: GetTextFieldPengajuan(
                controller: imagektp,
                label: "Fotokopi KTP",
                keyboardType: TextInputType.name,
                inputFormatters:
                    FilteringTextInputFormatter.singleLineFormatter,
              ),
            ),
            // Cetak Kartu Keluarga Baru
            if (widget.pengajuan.surat?.namaSurat ==
                    'Cetak Kartu Keluarga Baru' ||
                widget.pengajuan.surat?.namaSurat ==
                    'Surat Keterangan Kenal Lahir')
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Image.network(
                          Api.connectimage +
                              widget.pengajuan.imageSuratNikah!.trim(),
                        ),
                      );
                    },
                  );
                },
                child: GetTextFieldPengajuan(
                  controller: imagesuratnikah,
                  label: "Fotokopi Surat Nikah",
                  keyboardType: TextInputType.name,
                  inputFormatters:
                      FilteringTextInputFormatter.singleLineFormatter,
                ),
              ),
            if (widget.pengajuan.surat?.namaSurat ==
                    'Cetak Kartu Keluarga Baru' ||
                widget.pengajuan.surat?.namaSurat == 'Surat Keterangan Status')
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Image.network(
                          Api.connectimage +
                              widget.pengajuan.imageAktaCerai!.trim(),
                        ),
                      );
                    },
                  );
                },
                child: GetTextFieldPengajuan(
                  controller: imageaktacerai,
                  label: "Fotokopi Akta Cerai",
                  keyboardType: TextInputType.name,
                  inputFormatters:
                      FilteringTextInputFormatter.singleLineFormatter,
                ),
              ),
            // Cetak Kartu Keluarga Hilang
            if (widget.pengajuan.surat?.namaSurat ==
                'Cetak Kartu Keluarga Hilang')
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Image.network(
                          Api.connectimage +
                              widget.pengajuan.imageSuratKehilangan!.trim(),
                        ),
                      );
                    },
                  );
                },
                child: GetTextFieldPengajuan(
                  controller: imagesuratkehilangan,
                  label: "Surat Kehilangan",
                  keyboardType: TextInputType.name,
                  inputFormatters:
                      FilteringTextInputFormatter.singleLineFormatter,
                ),
              ),
            // Cetak Akta Kelahiran
            if (widget.pengajuan.surat?.namaSurat == 'Cetak Akta Kelahiran')
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Image.network(
                          Api.connectimage +
                              widget.pengajuan.imageSuratLahir!.trim(),
                        ),
                      );
                    },
                  );
                },
                child: GetTextFieldPengajuan(
                  controller: imagesuratlahir,
                  label: "Surat Lahir",
                  keyboardType: TextInputType.name,
                  inputFormatters:
                      FilteringTextInputFormatter.singleLineFormatter,
                ),
              ),
            if (widget.pengajuan.surat?.namaSurat == 'Cetak Akta Kelahiran' ||
                widget.pengajuan.surat?.namaSurat ==
                    'Surat Keterangan Kenal Lahir')
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Image.network(
                          Api.connectimage +
                              widget.pengajuan.imageBidan!.trim(),
                        ),
                      );
                    },
                  );
                },
                child: GetTextFieldPengajuan(
                  controller: imagebidan,
                  label: "Surat Bidan",
                  keyboardType: TextInputType.name,
                  inputFormatters:
                      FilteringTextInputFormatter.singleLineFormatter,
                ),
              ),
            // Cetak Akta Kematian
            if (widget.pengajuan.surat?.namaSurat == 'Cetak Akta Kematian' ||
                widget.pengajuan.surat?.namaSurat == 'Surat Keterangan Status')
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Image.network(
                          Api.connectimage +
                              widget.pengajuan.imageSuratKematian!.trim(),
                        ),
                      );
                    },
                  );
                },
                child: GetTextFieldPengajuan(
                  controller: imagesuratkematian,
                  label: "Surat Kematian dari Kelurahan",
                  keyboardType: TextInputType.name,
                  inputFormatters:
                      FilteringTextInputFormatter.singleLineFormatter,
                ),
              ),
            // Surat Keterangan Catatan Kepolisian
            if (widget.pengajuan.surat?.namaSurat ==
                    'Surat Keterangan Catatan Kepolisian' ||
                widget.pengajuan.surat?.namaSurat ==
                    'Surat Keterangan Hubungan Keluarga')
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Image.network(
                          Api.connectimage +
                              widget.pengajuan.imageAkteKelahiran!.trim(),
                        ),
                      );
                    },
                  );
                },
                child: GetTextFieldPengajuan(
                  controller: imageaktekelahiran,
                  label: "Fotokopi Akte Kelahiran",
                  keyboardType: TextInputType.name,
                  inputFormatters:
                      FilteringTextInputFormatter.singleLineFormatter,
                ),
              ),
            // Surat Keterangan Domisili PT
            if (widget.pengajuan.surat?.namaSurat ==
                'Surat Keterangan Domisili PT')
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Image.network(
                          Api.connectimage +
                              widget.pengajuan.imageSuratIzin!.trim(),
                        ),
                      );
                    },
                  );
                },
                child: GetTextFieldPengajuan(
                  controller: imagesuratizin,
                  label: "Fotokopi Surat Izin",
                  keyboardType: TextInputType.name,
                  inputFormatters:
                      FilteringTextInputFormatter.singleLineFormatter,
                ),
              ),
            // Surat Kepemilikan Kendaraan
            if (widget.pengajuan.surat?.namaSurat ==
                'Surat Kepemilikan Kendaraan')
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Image.network(
                          Api.connectimage + widget.pengajuan.imageSTNK!.trim(),
                        ),
                      );
                    },
                  );
                },
                child: GetTextFieldPengajuan(
                  controller: imagestnk,
                  label: "Fotokopi STNK",
                  keyboardType: TextInputType.name,
                  inputFormatters:
                      FilteringTextInputFormatter.singleLineFormatter,
                ),
              ),
            if (widget.pengajuan.surat?.namaSurat ==
                'Surat Kepemilikan Kendaraan')
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Image.network(
                          Api.connectimage + widget.pengajuan.imageBPKB!.trim(),
                        ),
                      );
                    },
                  );
                },
                child: GetTextFieldPengajuan(
                  controller: imagebpkb,
                  label: "Fotokopi BPKB",
                  keyboardType: TextInputType.name,
                  inputFormatters:
                      FilteringTextInputFormatter.singleLineFormatter,
                ),
              ),
            // Surat Transaksi Harga Tanah
            if (widget.pengajuan.surat?.namaSurat ==
                'Surat Transaksi Harga Tanah')
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Image.network(
                          Api.connectimage +
                              widget.pengajuan.imageSertifikat!.trim(),
                        ),
                      );
                    },
                  );
                },
                child: GetTextFieldPengajuan(
                  controller: imagesertifikat,
                  label: "Fotokopi Sertifikat",
                  keyboardType: TextInputType.name,
                  inputFormatters:
                      FilteringTextInputFormatter.singleLineFormatter,
                ),
              ),
            if (widget.pengajuan.surat?.namaSurat ==
                    'Surat Transaksi Harga Tanah' ||
                widget.pengajuan.surat?.namaSurat == 'Pengurusan SPPT PBB')
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Image.network(
                          Api.connectimage + widget.pengajuan.imageSPPT!.trim(),
                        ),
                      );
                    },
                  );
                },
                child: GetTextFieldPengajuan(
                  controller: imagesppt,
                  label: "Fotokopi SPPT PBB",
                  keyboardType: TextInputType.name,
                  inputFormatters:
                      FilteringTextInputFormatter.singleLineFormatter,
                ),
              ),
              if(widget.pengajuan.surat?.namaSurat == 'Pengurusan SPPT PBB')
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Image.network(
                          Api.connectimage +
                              widget.pengajuan.imageSuratTanah!.trim(),
                        ),
                      );
                    },
                  );
                },
                child: GetTextFieldPengajuan(
                  controller: imagesurattanah,
                  label: "Fotokopi Surat Tanah",
                  keyboardType: TextInputType.name,
                  inputFormatters:
                      FilteringTextInputFormatter.singleLineFormatter,
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: white,
        child: Container(
          padding: EdgeInsets.all(5),
          height: 70,
          color: white,
          child: Container(
            margin: EdgeInsets.all(8),
            height: 40,
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
              onPressed: () {
                showSuccessDialog(
                    context, widget.pengajuan.idPengajuan.toString());
              },
              child: Text(
                'Batalkan Surat',
                style: MyFont.poppins(fontSize: 12, color: white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
