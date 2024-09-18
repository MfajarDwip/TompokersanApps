import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_kepuharjo_new/Model/Pengajuan.dart';
import 'package:mobile_kepuharjo_new/Resource/MyTextField.dart';
import 'package:mobile_kepuharjo_new/Resource/Mycolor.dart';
import 'package:mobile_kepuharjo_new/Resource/Myfont.dart';
import 'package:mobile_kepuharjo_new/Services/api_connect.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_kepuharjo_new/Services/api_services.dart';

class SuratMasuk extends StatefulWidget {
  const SuratMasuk({super.key});

  @override
  State<SuratMasuk> createState() => _SuratMasukState();
}

class _SuratMasukState extends State<SuratMasuk> {
  List<Pengajuan> pengajuan = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getSuratMasuk();
  }

  Future<void> _getSuratMasuk() async {
    final api = ApiServices();
    final surat = await api.getPengajuanRt("Diajukan");
    setState(() {
      pengajuan = surat;
    });
  }

  ApiServices apiServices = ApiServices();
  
  Future<void> status_setuju(String id, String nopengantar) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final response = await http.post(
        Uri.parse("${Api.status_setuju_rt}/$id"),
        body: jsonEncode({"no_pengantar": nopengantar}),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['message'] == 'Status surat dan file PDF berhasil diperbarui') {
          Fluttertoast.showToast(
            msg: "Status pengajuan berhasil disetujui dan PDF telah digenerate",
            backgroundColor: Colors.black.withOpacity(0.7),
          );
          setState(() {
            _getSuratMasuk();
          });
        } else {
          Fluttertoast.showToast(
            msg: data['message'],
            backgroundColor: Colors.red,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: 'Terjadi kesalahan: ${response.reasonPhrase}',
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Gagal mengirim notifikasi',
        backgroundColor: Colors.red,
      );
    }
  }

  Future status_tolak(String id, String keteranganTolak) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      var res = await http.post(Uri.parse("${Api.status_tolak_rt}/$id"),
          body: {"keterangan_ditolak": keteranganTolak},
          headers: {"Authorization": "Bearer $token"});
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        if (data['message'] == "Status surat updated successfully") {
          Fluttertoast.showToast(
              msg: "Status pengajuan berhasil ditolak",
              backgroundColor: black.withOpacity(0.7));
          setState(() {
            noPengantar.clear();
            ketDitolak.clear();
            _getSuratMasuk();
          });
          // apiServices.sendNotification(
          //     "Pengajuan surat anda ditolak oleh pihak RT",
          //     tokenfcm,
          //     "Pengajuan Surat Ditolak");
        }
      } else {
        Fluttertoast.showToast(
            msg: data['message'], backgroundColor: Colors.red);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  TextEditingController ketDitolak = TextEditingController();
  TextEditingController noPengantar = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _getSuratMasuk();
          });
        },
        child: SingleChildScrollView(
            child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(10),
              child: Card(
                elevation: 3, // tinggi bayangan
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Surat Masuk",
                              style: MyFont.poppins(
                                  fontSize: 14,
                                  color: black,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Menampilkan data surat masuk untuk disetujui maupun ditolak",
                              style: MyFont.poppins(
                                  fontSize: 12,
                                  color: softgrey,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                            columns: [
                              DataColumn(
                                label: Text(
                                  "No.",
                                  style: MyFont.poppins(
                                      fontSize: 12, color: black),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  "Nama",
                                  style: MyFont.poppins(
                                      fontSize: 12, color: black),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  "Jenis",
                                  style: MyFont.poppins(
                                      fontSize: 12, color: black),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  "Status",
                                  style: MyFont.poppins(
                                      fontSize: 12, color: black),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  "Proses",
                                  style: MyFont.poppins(
                                      fontSize: 12, color: black),
                                ),
                              ),
                            ],
                            rows: pengajuan.map((e) {
                              return DataRow(cells: [
                                DataCell(Text(
                                  ('${pengajuan.indexOf(e) + 1}').toString(),
                                  style: MyFont.poppins(
                                      fontSize: 11, color: black),
                                )),
                                DataCell(Text(
                                  e.masyarakat!.namaLengkap.toString(),
                                  style: MyFont.poppins(
                                      fontSize: 11, color: black),
                                )),
                                DataCell(Text(
                                  e.surat!.namaSurat.toString(),
                                  style: MyFont.poppins(
                                      fontSize: 11, color: black),
                                )),
                                DataCell(Container(
                                  height: 25,
                                  width: 80,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey.withOpacity(0.2)),
                                  child: Center(
                                    child: Text(
                                      e.status.toString(),
                                      textAlign: TextAlign.center,
                                      style: MyFont.poppins(
                                          fontSize: 11,
                                          color: black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )),
                                DataCell(SizedBox(
                                  height: 35,
                                  width: 100,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: blue,
                                          shadowColor: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          )),
                                      onPressed: () {
                                        int index = pengajuan.indexOf(e);
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              scrollable: true,
                                              content: SingleChildScrollView(
                                                child: Column(
                                                  children: [
                                                    GetTextFieldUser(
                                                      controller: noPengantar,
                                                      label: "No. Pengantar",
                                                      isEnable: true,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      inputFormatters:
                                                          FilteringTextInputFormatter
                                                              .singleLineFormatter,
                                                      length: 255,
                                                      icon: Icons.receipt,
                                                    ),
                                                    GetTextFieldUser(
                                                      controller:
                                                          TextEditingController(
                                                              text: pengajuan[
                                                                      index]
                                                                  .masyarakat!
                                                                  .nik
                                                                  .toString()),
                                                      label:
                                                          "Nomor Induk Keluarga",
                                                      isEnable: false,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      inputFormatters:
                                                          FilteringTextInputFormatter
                                                              .digitsOnly,
                                                      length: 16,
                                                      icon: Icons.badge,
                                                    ),
                                                    GetTextFieldUser(
                                                      controller:
                                                          TextEditingController(
                                                              text: pengajuan[
                                                                      index]
                                                                  .masyarakat!
                                                                  .namaLengkap
                                                                  .toString()),
                                                      label: "Nama Lengkap",
                                                      isEnable: false,
                                                      keyboardType:
                                                          TextInputType.name,
                                                      inputFormatters:
                                                          FilteringTextInputFormatter
                                                              .digitsOnly,
                                                      length: 16,
                                                      icon: Icons.person,
                                                    ),
                                                    GetTextFieldUser(
                                                      controller:
                                                          TextEditingController(
                                                              text:
                                                                  "${pengajuan[index].masyarakat!.tempatLahir}, ${pengajuan[index].masyarakat!.tglLahir}"),
                                                      label:
                                                          "Tempat, Tanggal Lahir",
                                                      isEnable: false,
                                                      keyboardType:
                                                          TextInputType.name,
                                                      inputFormatters:
                                                          FilteringTextInputFormatter
                                                              .digitsOnly,
                                                      length: 16,
                                                      icon:
                                                          Icons.calendar_month,
                                                    ),
                                                    GetTextFieldUser(
                                                      controller:
                                                          TextEditingController(
                                                              text: pengajuan[
                                                                      index]
                                                                  .masyarakat!
                                                                  .jenisKelamin
                                                                  .toString()),
                                                      label: "Jenis Kelamin",
                                                      isEnable: false,
                                                      keyboardType:
                                                          TextInputType.name,
                                                      inputFormatters:
                                                          FilteringTextInputFormatter
                                                              .digitsOnly,
                                                      length: 16,
                                                      icon:
                                                          Icons.man_3_outlined,
                                                    ),
                                                    GetTextFieldUser(
                                                      controller:
                                                          TextEditingController(
                                                              text: pengajuan[
                                                                      index]
                                                                  .masyarakat!
                                                                  .agama
                                                                  .toString()),
                                                      label: "Agama",
                                                      isEnable: false,
                                                      keyboardType:
                                                          TextInputType.name,
                                                      inputFormatters:
                                                          FilteringTextInputFormatter
                                                              .digitsOnly,
                                                      length: 16,
                                                      icon:
                                                          Icons.account_balance,
                                                    ),
                                                    GetTextFieldUser(
                                                      controller:
                                                          TextEditingController(
                                                              text: pengajuan[
                                                                      index]
                                                                  .masyarakat!
                                                                  .pendidikan
                                                                  .toString()),
                                                      label: "Pendidikan",
                                                      isEnable: false,
                                                      keyboardType:
                                                          TextInputType.name,
                                                      inputFormatters:
                                                          FilteringTextInputFormatter
                                                              .digitsOnly,
                                                      length: 16,
                                                      icon: Icons.school,
                                                    ),
                                                    GetTextFieldUser(
                                                      controller:
                                                          TextEditingController(
                                                              text: pengajuan[
                                                                      index]
                                                                  .masyarakat!
                                                                  .pekerjaan
                                                                  .toString()),
                                                      label: "Pekerjaan",
                                                      isEnable: false,
                                                      keyboardType:
                                                          TextInputType.name,
                                                      inputFormatters:
                                                          FilteringTextInputFormatter
                                                              .digitsOnly,
                                                      length: 16,
                                                      icon: Icons.work,
                                                    ),
                                                    GetTextFieldUser(
                                                      controller:
                                                          TextEditingController(
                                                              text: pengajuan[
                                                                      index]
                                                                  .masyarakat!
                                                                  .golonganDarah
                                                                  .toString()),
                                                      label: "Golongan Darah",
                                                      isEnable: false,
                                                      keyboardType:
                                                          TextInputType.name,
                                                      inputFormatters:
                                                          FilteringTextInputFormatter
                                                              .digitsOnly,
                                                      length: 16,
                                                      icon: Icons.opacity,
                                                    ),
                                                    GetTextFieldUser(
                                                      controller:
                                                          TextEditingController(
                                                              text: pengajuan[
                                                                      index]
                                                                  .masyarakat!
                                                                  .statusPerkawinan
                                                                  .toString()),
                                                      label:
                                                          "Status Perkawinan",
                                                      isEnable: false,
                                                      keyboardType:
                                                          TextInputType.name,
                                                      inputFormatters:
                                                          FilteringTextInputFormatter
                                                              .digitsOnly,
                                                      length: 16,
                                                      icon:
                                                          Icons.people_rounded,
                                                    ),
                                                    GetTextFieldUser(
                                                      controller: ketDitolak,
                                                      label:
                                                          "Keterangan Ditolak",
                                                      isEnable: true,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      inputFormatters:
                                                          FilteringTextInputFormatter
                                                              .singleLineFormatter,
                                                      length: 255,
                                                      icon: Icons
                                                          .highlight_off_rounded,
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.image,
                                                          size: 25,
                                                          color: grey,
                                                        ),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "Fotokopi Kartu Keluarga",
                                                              style: MyFont
                                                                  .poppins(
                                                                      fontSize:
                                                                          11,
                                                                      color:
                                                                          black),
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return AlertDialog(
                                                                      content: Image
                                                                          .network(
                                                                        Api.connectimage +
                                                                            pengajuan[index].imageKk.toString(),
                                                                        errorBuilder: (context,
                                                                            error,
                                                                            stackTrace) {
                                                                          return Text(
                                                                              'Gagal memuat gambar');
                                                                        },
                                                                      ),
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                              child: Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(8),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.2),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                ),
                                                                child: Text(
                                                                  pengajuan[
                                                                          index]
                                                                      .imageKk
                                                                      .toString(),
                                                                  style: MyFont.poppins(
                                                                      fontSize:
                                                                          11,
                                                                      color:
                                                                          black),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.image,
                                                          size: 25,
                                                          color: grey,
                                                        ),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "Fotokopi KTP",
                                                              style: MyFont
                                                                  .poppins(
                                                                      fontSize:
                                                                          11,
                                                                      color:
                                                                          black),
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return AlertDialog(
                                                                      content: Image
                                                                          .network(
                                                                        Api.connectimage +
                                                                            pengajuan[index].imageKTP.toString(),
                                                                        errorBuilder: (context,
                                                                            error,
                                                                            stackTrace) {
                                                                          return Text(
                                                                              'Gagal memuat gambar');
                                                                        },
                                                                      ),
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                              child: Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(8),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.2),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                ),
                                                                child: Text(
                                                                  pengajuan[
                                                                          index]
                                                                      .imageKTP
                                                                      .toString(),
                                                                  style: MyFont.poppins(
                                                                      fontSize:
                                                                          11,
                                                                      color:
                                                                          black),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    if (pengajuan[index].surat!.namaSurat.toString() == 'Cetak Kartu Keluarga Baru' ||
                                                        pengajuan[index]
                                                                .surat!
                                                                .namaSurat
                                                                .toString() ==
                                                            'Cetak Akta Kelahiran' ||
                                                        pengajuan[index]
                                                                .surat!
                                                                .namaSurat
                                                                .toString() ==
                                                            'Surat Keterangan Kenal Lahir')
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons.image,
                                                            size: 25,
                                                            color: grey,
                                                          ),
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "Fotokopi Surat Nikah",
                                                                style: MyFont
                                                                    .poppins(
                                                                        fontSize:
                                                                            11,
                                                                        color:
                                                                            black),
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return AlertDialog(
                                                                        content:
                                                                            Image.network(
                                                                          Api.connectimage +
                                                                              pengajuan[index].imageSuratNikah.toString(),
                                                                          errorBuilder: (context,
                                                                              error,
                                                                              stackTrace) {
                                                                            return Text('Gagal memuat gambar');
                                                                          },
                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              8),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.2),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                  ),
                                                                  child: Text(
                                                                    pengajuan[
                                                                            index]
                                                                        .imageSuratNikah
                                                                        .toString(),
                                                                    style: MyFont.poppins(
                                                                        fontSize:
                                                                            11,
                                                                        color:
                                                                            black),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    if (pengajuan[index]
                                                                .surat!
                                                                .namaSurat
                                                                .toString() ==
                                                            'Cetak Kartu Keluarga Baru' ||
                                                        pengajuan[index]
                                                                .surat!
                                                                .namaSurat
                                                                .toString() ==
                                                            'Surat Keterangan Status')
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons.image,
                                                            size: 25,
                                                            color: grey,
                                                          ),
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "Fotokopi Akta Cerai",
                                                                style: MyFont
                                                                    .poppins(
                                                                        fontSize:
                                                                            11,
                                                                        color:
                                                                            black),
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return AlertDialog(
                                                                        content:
                                                                            Image.network(
                                                                          Api.connectimage +
                                                                              pengajuan[index].imageAktaCerai.toString(),
                                                                          errorBuilder: (context,
                                                                              error,
                                                                              stackTrace) {
                                                                            return Text('Gagal memuat gambar');
                                                                          },
                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              8),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.2),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                  ),
                                                                  child: Text(
                                                                    pengajuan[
                                                                            index]
                                                                        .imageAktaCerai
                                                                        .toString(),
                                                                    style: MyFont.poppins(
                                                                        fontSize:
                                                                            11,
                                                                        color:
                                                                            black),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    if (pengajuan[index]
                                                            .surat!
                                                            .namaSurat
                                                            .toString() ==
                                                        'Cetak Kartu Keluarga Hilang')
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons.image,
                                                            size: 25,
                                                            color: grey,
                                                          ),
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "Surat Kehilangan",
                                                                style: MyFont
                                                                    .poppins(
                                                                        fontSize:
                                                                            11,
                                                                        color:
                                                                            black),
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return AlertDialog(
                                                                        content:
                                                                            Image.network(
                                                                          Api.connectimage +
                                                                              pengajuan[index].imageSuratKehilangan.toString(),
                                                                          errorBuilder: (context,
                                                                              error,
                                                                              stackTrace) {
                                                                            return Text('Gagal memuat gambar');
                                                                          },
                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              8),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.2),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                  ),
                                                                  child: Text(
                                                                    pengajuan[
                                                                            index]
                                                                        .imageSuratKehilangan
                                                                        .toString(),
                                                                    style: MyFont.poppins(
                                                                        fontSize:
                                                                            11,
                                                                        color:
                                                                            black),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    if (pengajuan[index]
                                                                .surat!
                                                                .namaSurat
                                                                .toString() ==
                                                            'Cetak Akta Kelahiran' ||
                                                        pengajuan[index]
                                                                .surat!
                                                                .namaSurat
                                                                .toString() ==
                                                            'Surat Keterangan Kenal Lahir')
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons.image,
                                                            size: 25,
                                                            color: grey,
                                                          ),
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "Surat Bidan",
                                                                style: MyFont
                                                                    .poppins(
                                                                        fontSize:
                                                                            11,
                                                                        color:
                                                                            black),
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return AlertDialog(
                                                                        content:
                                                                            Image.network(
                                                                          Api.connectimage +
                                                                              pengajuan[index].imageBidan.toString(),
                                                                          errorBuilder: (context,
                                                                              error,
                                                                              stackTrace) {
                                                                            return Text('Gagal memuat gambar');
                                                                          },
                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              8),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.2),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                  ),
                                                                  child: Text(
                                                                    pengajuan[
                                                                            index]
                                                                        .imageBidan
                                                                        .toString(),
                                                                    style: MyFont.poppins(
                                                                        fontSize:
                                                                            11,
                                                                        color:
                                                                            black),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    if (pengajuan[index]
                                                            .surat!
                                                            .namaSurat
                                                            .toString() ==
                                                        'Cetak Akta Kelahiran')
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons.image,
                                                            size: 25,
                                                            color: grey,
                                                          ),
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "Surat Lahir dari kelurahan",
                                                                style: MyFont
                                                                    .poppins(
                                                                        fontSize:
                                                                            11,
                                                                        color:
                                                                            black),
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return AlertDialog(
                                                                        content:
                                                                            Image.network(
                                                                          Api.connectimage +
                                                                              pengajuan[index].imageSuratLahir.toString(),
                                                                          errorBuilder: (context,
                                                                              error,
                                                                              stackTrace) {
                                                                            return Text('Gagal memuat gambar');
                                                                          },
                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              8),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.2),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                  ),
                                                                  child: Text(
                                                                    pengajuan[
                                                                            index]
                                                                        .imageSuratLahir
                                                                        .toString(),
                                                                    style: MyFont.poppins(
                                                                        fontSize:
                                                                            11,
                                                                        color:
                                                                            black),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    if (pengajuan[index]
                                                                .surat!
                                                                .namaSurat
                                                                .toString() ==
                                                            'Surat Keterangan Catatan Kepolisian' ||
                                                        pengajuan[index]
                                                                .surat!
                                                                .namaSurat
                                                                .toString() ==
                                                            'Surat Keterangan Hubungan Keluarga')
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons.image,
                                                            size: 25,
                                                            color: grey,
                                                          ),
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "Fotokopi Akte Kelahiran",
                                                                style: MyFont
                                                                    .poppins(
                                                                        fontSize:
                                                                            11,
                                                                        color:
                                                                            black),
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return AlertDialog(
                                                                        content:
                                                                            Image.network(
                                                                          Api.connectimage +
                                                                              pengajuan[index].imageAkteKelahiran.toString(),
                                                                          errorBuilder: (context,
                                                                              error,
                                                                              stackTrace) {
                                                                            return Text('Gagal memuat gambar');
                                                                          },
                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              8),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.2),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                  ),
                                                                  child: Text(
                                                                    pengajuan[
                                                                            index]
                                                                        .imageAkteKelahiran
                                                                        .toString(),
                                                                    style: MyFont.poppins(
                                                                        fontSize:
                                                                            11,
                                                                        color:
                                                                            black),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    if (pengajuan[index]
                                                            .surat!
                                                            .namaSurat
                                                            .toString() ==
                                                        'Surat Keterangan Domisili PT')
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons.image,
                                                            size: 25,
                                                            color: grey,
                                                          ),
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "Fotokopi Surat Izin",
                                                                style: MyFont
                                                                    .poppins(
                                                                        fontSize:
                                                                            11,
                                                                        color:
                                                                            black),
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return AlertDialog(
                                                                        content:
                                                                            Image.network(
                                                                          Api.connectimage +
                                                                              pengajuan[index].imageSuratIzin.toString(),
                                                                          errorBuilder: (context,
                                                                              error,
                                                                              stackTrace) {
                                                                            return Text('Gagal memuat gambar');
                                                                          },
                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              8),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.2),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                  ),
                                                                  child: Text(
                                                                    pengajuan[
                                                                            index]
                                                                        .imageSuratIzin
                                                                        .toString(),
                                                                    style: MyFont.poppins(
                                                                        fontSize:
                                                                            11,
                                                                        color:
                                                                            black),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    if (pengajuan[index]
                                                            .surat!
                                                            .namaSurat
                                                            .toString() ==
                                                        'Surat Kepemilikan Kendaraan')
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons.image,
                                                            size: 25,
                                                            color: grey,
                                                          ),
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "Fotokopi STNK",
                                                                style: MyFont
                                                                    .poppins(
                                                                        fontSize:
                                                                            11,
                                                                        color:
                                                                            black),
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return AlertDialog(
                                                                        content:
                                                                            Image.network(
                                                                          Api.connectimage +
                                                                              pengajuan[index].imageSTNK.toString(),
                                                                          errorBuilder: (context,
                                                                              error,
                                                                              stackTrace) {
                                                                            return Text('Gagal memuat gambar');
                                                                          },
                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              8),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.2),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                  ),
                                                                  child: Text(
                                                                    pengajuan[
                                                                            index]
                                                                        .imageSTNK
                                                                        .toString(),
                                                                    style: MyFont.poppins(
                                                                        fontSize:
                                                                            11,
                                                                        color:
                                                                            black),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    if (pengajuan[index]
                                                            .surat!
                                                            .namaSurat
                                                            .toString() ==
                                                        'Surat Kepemilikan Kendaraan')
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons.image,
                                                            size: 25,
                                                            color: grey,
                                                          ),
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "Fotokopi BPKB",
                                                                style: MyFont
                                                                    .poppins(
                                                                        fontSize:
                                                                            11,
                                                                        color:
                                                                            black),
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return AlertDialog(
                                                                        content:
                                                                            Image.network(
                                                                          Api.connectimage +
                                                                              pengajuan[index].imageBPKB.toString(),
                                                                          errorBuilder: (context,
                                                                              error,
                                                                              stackTrace) {
                                                                            return Text('Gagal memuat gambar');
                                                                          },
                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              8),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.2),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                  ),
                                                                  child: Text(
                                                                    pengajuan[
                                                                            index]
                                                                        .imageBPKB
                                                                        .toString(),
                                                                    style: MyFont.poppins(
                                                                        fontSize:
                                                                            11,
                                                                        color:
                                                                            black),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    if (pengajuan[index]
                                                            .surat!
                                                            .namaSurat
                                                            .toString() ==
                                                        'Pengurusan SPPT PBB')
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons.image,
                                                            size: 25,
                                                            color: grey,
                                                          ),
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "Fotokopi Surat Tanah",
                                                                style: MyFont
                                                                    .poppins(
                                                                        fontSize:
                                                                            11,
                                                                        color:
                                                                            black),
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return AlertDialog(
                                                                        content:
                                                                            Image.network(
                                                                          Api.connectimage +
                                                                              pengajuan[index].imageSuratTanah.toString(),
                                                                          errorBuilder: (context,
                                                                              error,
                                                                              stackTrace) {
                                                                            return Text('Gagal memuat gambar');
                                                                          },
                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              8),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.2),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                  ),
                                                                  child: Text(
                                                                    pengajuan[
                                                                            index]
                                                                        .imageSuratTanah
                                                                        .toString(),
                                                                    style: MyFont.poppins(
                                                                        fontSize:
                                                                            11,
                                                                        color:
                                                                            black),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    if (pengajuan[index]
                                                            .surat!
                                                            .namaSurat
                                                            .toString() ==
                                                        'Surat Transaksi Harga Tanah')
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons.image,
                                                            size: 25,
                                                            color: grey,
                                                          ),
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "Fotokopi Sertifikat",
                                                                style: MyFont
                                                                    .poppins(
                                                                        fontSize:
                                                                            11,
                                                                        color:
                                                                            black),
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return AlertDialog(
                                                                        content:
                                                                            Image.network(
                                                                          Api.connectimage +
                                                                              pengajuan[index].imageSertifikat.toString(),
                                                                          errorBuilder: (context,
                                                                              error,
                                                                              stackTrace) {
                                                                            return Text('Gagal memuat gambar');
                                                                          },
                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              8),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.2),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                  ),
                                                                  child: Text(
                                                                    pengajuan[
                                                                            index]
                                                                        .imageSertifikat
                                                                        .toString(),
                                                                    style: MyFont.poppins(
                                                                        fontSize:
                                                                            11,
                                                                        color:
                                                                            black),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    if (pengajuan[index]
                                                                .surat!
                                                                .namaSurat
                                                                .toString() ==
                                                            'Cetak Akta Kematian' ||
                                                        pengajuan[index]
                                                                .surat!
                                                                .namaSurat
                                                                .toString() ==
                                                            'Surat Keterangan Status')
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons.image,
                                                            size: 25,
                                                            color: grey,
                                                          ),
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "Fotokopi Surat Kematian",
                                                                style: MyFont
                                                                    .poppins(
                                                                        fontSize:
                                                                            11,
                                                                        color:
                                                                            black),
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return AlertDialog(
                                                                        content:
                                                                            Image.network(
                                                                          Api.connectimage +
                                                                              pengajuan[index].imageSuratKematian.toString(),
                                                                          errorBuilder: (context,
                                                                              error,
                                                                              stackTrace) {
                                                                            return Text('Gagal memuat gambar');
                                                                          },
                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              8),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.2),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                  ),
                                                                  child: Text(
                                                                    pengajuan[
                                                                            index]
                                                                        .imageSuratKematian
                                                                        .toString(),
                                                                    style: MyFont.poppins(
                                                                        fontSize:
                                                                            11,
                                                                        color:
                                                                            black),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    if (pengajuan[index]
                                                                .surat!
                                                                .namaSurat
                                                                .toString() ==
                                                            'Surat Transaksi Harga Tanah' ||
                                                        pengajuan[index]
                                                                .surat!
                                                                .namaSurat
                                                                .toString() ==
                                                            'Pengurusan SPPT PBB')
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons.image,
                                                            size: 25,
                                                            color: grey,
                                                          ),
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "Fotokopi SPPT PBB",
                                                                style: MyFont
                                                                    .poppins(
                                                                        fontSize:
                                                                            11,
                                                                        color:
                                                                            black),
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return AlertDialog(
                                                                        content:
                                                                            Image.network(
                                                                          Api.connectimage +
                                                                              pengajuan[index].imageSPPT.toString(),
                                                                          errorBuilder: (context,
                                                                              error,
                                                                              stackTrace) {
                                                                            return Text('Gagal memuat gambar');
                                                                          },
                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              8),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.2),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                  ),
                                                                  child: Text(
                                                                    pengajuan[
                                                                            index]
                                                                        .imageSPPT
                                                                        .toString(),
                                                                    style: MyFont.poppins(
                                                                        fontSize:
                                                                            11,
                                                                        color:
                                                                            black),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        SizedBox(
                                                          height: 40,
                                                          width: 90,
                                                          child: ElevatedButton(
                                                              style: ElevatedButton
                                                                  .styleFrom(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .green,
                                                                      shadowColor:
                                                                          Colors
                                                                              .transparent,
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                      )),
                                                              onPressed: () {
                                                                setState(() {
                                                                  if (noPengantar
                                                                      .text
                                                                      .isEmpty) {
                                                                    Fluttertoast.showToast(
                                                                        msg:
                                                                            "Silahkan Isi No. Pengantar",
                                                                        backgroundColor: Colors
                                                                            .black
                                                                            .withOpacity(0.7));
                                                                  } else {
                                                                    status_setuju(
                                                                        pengajuan[index]
                                                                            .idPengajuan
                                                                            .toString(),
                                                                        noPengantar
                                                                            .text);
                                                                    apiServices
                                                                        .sendNotificationRw();
                                                                    apiServices.sendNotificationUser(
                                                                        "Pengajuan surat anda telah disetujui oleh pihak RT",
                                                                        "Pengajuan Surat Disetujui",
                                                                        pengajuan[index]
                                                                            .masyarakat!
                                                                            .nik
                                                                            .toString());
                                                                    status_setuju(
                                                                      pengajuan[
                                                                              index]
                                                                          .idPengajuan
                                                                          .toString(),
                                                                      noPengantar
                                                                          .text,
                                                                    );
                                                                    _getSuratMasuk();
                                                                    Navigator.pop(
                                                                        context);
                                                                  }
                                                                });
                                                              },
                                                              child: Text(
                                                                "Setujui",
                                                                style: MyFont
                                                                    .poppins(
                                                                        fontSize:
                                                                            12,
                                                                        color:
                                                                            white),
                                                              )),
                                                        ),
                                                        SizedBox(
                                                          height: 40,
                                                          width: 80,
                                                          child: ElevatedButton(
                                                              style: ElevatedButton
                                                                  .styleFrom(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .red,
                                                                      shadowColor:
                                                                          Colors
                                                                              .transparent,
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                      )),
                                                              onPressed: () {
                                                                setState(() {
                                                                  if (ketDitolak
                                                                      .text
                                                                      .isEmpty) {
                                                                    Fluttertoast.showToast(
                                                                        msg:
                                                                            "Silahkan Isi Keterangan Ditolak",
                                                                        backgroundColor:
                                                                            black.withOpacity(0.7));
                                                                  } else {
                                                                    _getSuratMasuk();
                                                                    apiServices.sendNotificationUser(
                                                                        "Pengajuan surat anda ditolak oleh pihak RW",
                                                                        "Pengajuan Surat Ditolak",
                                                                        pengajuan[index]
                                                                            .masyarakat!
                                                                            .nik
                                                                            .toString());
                                                                    status_tolak(
                                                                      pengajuan[
                                                                              index]
                                                                          .idPengajuan
                                                                          .toString(),
                                                                      ketDitolak
                                                                          .text,
                                                                    );
                                                                    Navigator.pop(
                                                                        context);
                                                                  }
                                                                });
                                                              },
                                                              child: Text(
                                                                "Tolak",
                                                                style: MyFont
                                                                    .poppins(
                                                                        fontSize:
                                                                            12,
                                                                        color:
                                                                            white),
                                                              )),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Text(
                                        'Preview Data',
                                        style: MyFont.poppins(
                                            fontSize: 11, color: white),
                                      )),
                                ))
                              ]);
                            }).toList()),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}
