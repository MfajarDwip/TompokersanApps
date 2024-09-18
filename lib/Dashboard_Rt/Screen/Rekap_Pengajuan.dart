import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_kepuharjo_new/Model/Pengajuan.dart';
import 'package:mobile_kepuharjo_new/Resource/MyTextField.dart';
import 'package:mobile_kepuharjo_new/Resource/Mycolor.dart';
import 'package:mobile_kepuharjo_new/Resource/Myfont.dart';
import 'package:mobile_kepuharjo_new/Services/api_connect.dart';
import 'package:mobile_kepuharjo_new/Services/api_services.dart';

class RekapPengajuan extends StatefulWidget {
  const RekapPengajuan({super.key});

  @override
  State<RekapPengajuan> createState() => _RekapPengajuanState();
}

class _RekapPengajuanState extends State<RekapPengajuan> {
  List<Pengajuan> pengajuan = [];
  int currentPage = 1;
  int lastPage = 1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRekapPengajuan(currentPage);
  }

  Future<void> getRekapPengajuan(int page) async {
    final api = ApiServices();
    final response = await api.getRekapRt(page);
    setState(() {
      pengajuan = response['pengajuanList'];
      lastPage = response['lastPage'];
      currentPage = page;
    });
  }

  Future<void> _loadNextPage() async {
    if (currentPage < lastPage) {
      await getRekapPengajuan(currentPage + 1);
    }
  }

  Future<void> _loadPreviousPage() async {
    if (currentPage > 1) {
      await getRekapPengajuan(currentPage - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 1,
            padding: EdgeInsets.all(10),
            child: Card(
              elevation: 3, // tinggi bayangan
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Rekap Surat",
                                style: MyFont.poppins(
                                    fontSize: 14,
                                    color: black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Menampilkan hasil data semua surat",
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
                                    "Keterangan",
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
                                    e.masyarakat!.namaLengkap!,
                                    style: MyFont.poppins(
                                        fontSize: 11, color: black),
                                  )),
                                  DataCell(Text(
                                    e.keterangan.toString(),
                                    style: MyFont.poppins(
                                        fontSize: 11, color: black),
                                  )),
                                  DataCell(Text(
                                    e.surat!.namaSurat.toString(),
                                    style: MyFont.poppins(
                                        fontSize: 11, color: black),
                                  )),
                                  DataCell(Container(
                                    height: 20,
                                    width: 80,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: (e.status.toString() ==
                                                "Diajukan")
                                            ? Colors.amberAccent
                                            : (e.status.toString() ==
                                                    "Disetujui RT"
                                                ? Colors.green
                                                : (e.status.toString() ==
                                                        "Ditolak RT")
                                                    ? Colors.red
                                                    : (e.status.toString() ==
                                                            "Disetujui RW")
                                                        ? Colors.green
                                                        : Colors.grey)),
                                    child: Center(
                                      child: Text(
                                        e.status.toString(),
                                        textAlign: TextAlign.center,
                                        style: MyFont.poppins(
                                            fontSize: 11, color: white),
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
                                                      Visibility(
                                                        visible: pengajuan[
                                                                        index]
                                                                    .noPengantar !=
                                                                null &&
                                                            pengajuan[index]
                                                                .noPengantar
                                                                .toString()
                                                                .isNotEmpty,
                                                        child: GetTextFieldUser(
                                                          controller:
                                                              TextEditingController(
                                                                  text: pengajuan[
                                                                          index]
                                                                      .noPengantar
                                                                      .toString()),
                                                          label:
                                                              "No. Pengantar",
                                                          isEnable: true,
                                                          keyboardType:
                                                              TextInputType
                                                                  .text,
                                                          inputFormatters:
                                                              FilteringTextInputFormatter
                                                                  .singleLineFormatter,
                                                          length: 255,
                                                          icon: Icons.receipt,
                                                        ),
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
                                                            TextInputType
                                                                .number,
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
                                                        icon: Icons
                                                            .calendar_month,
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
                                                        icon: Icons
                                                            .man_3_outlined,
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
                                                        icon: Icons
                                                            .account_balance,
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
                                                        icon: Icons
                                                            .people_rounded,
                                                      ),
                                                      Visibility(
                                                        visible: pengajuan[
                                                                        index]
                                                                    .keteranganDitolak !=
                                                                null &&
                                                            pengajuan[index]
                                                                .keteranganDitolak
                                                                .toString()
                                                                .isNotEmpty,
                                                        child: GetTextFieldUser(
                                                          controller: TextEditingController(
                                                              text: pengajuan[
                                                                      index]
                                                                  .keteranganDitolak
                                                                  .toString()),
                                                          label:
                                                              "Keterangan Ditolak",
                                                          isEnable: true,
                                                          keyboardType:
                                                              TextInputType
                                                                  .text,
                                                          inputFormatters:
                                                              FilteringTextInputFormatter
                                                                  .singleLineFormatter,
                                                          length: 255,
                                                          icon: Icons
                                                              .highlight_off_rounded,
                                                        ),
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
                                                                        content:
                                                                            Image.network(
                                                                          Api.connectimage +
                                                                              pengajuan[index].imageKk.toString(),
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
                                                                        content:
                                                                            Image.network(
                                                                          Api.connectimage +
                                                                              pengajuan[index].imageKTP.toString(),
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
                                                                  style: MyFont.poppins(
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
                                                                            .all(8),
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
                                                                  style: MyFont.poppins(
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
                                                                            .all(8),
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
                                                                  style: MyFont.poppins(
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
                                                                            .all(8),
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
                                                                  style: MyFont.poppins(
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
                                                                            .all(8),
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
                                                                  style: MyFont.poppins(
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
                                                                            .all(8),
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
                                                                  style: MyFont.poppins(
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
                                                                            .all(8),
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
                                                                  style: MyFont.poppins(
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
                                                                            .all(8),
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
                                                                  style: MyFont.poppins(
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
                                                                            .all(8),
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
                                                                  style: MyFont.poppins(
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
                                                                            .all(8),
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
                                                                  style: MyFont.poppins(
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
                                                                            .all(8),
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
                                                                  style: MyFont.poppins(
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
                                                                            .all(8),
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
                                                                  style: MyFont.poppins(
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
                                                                            .all(8),
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
                                                                  style: MyFont.poppins(
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
                                                                            .all(8),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _loadPreviousPage();
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              color: softgrey,
                              // Tidak ada halaman berikutnya jika currentPage adalah lastPage
                              child: Align(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.keyboard_arrow_left_rounded,
                                  color: white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              _loadNextPage();
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              color: primaryColor,
                              // Tidak ada halaman berikutnya jika currentPage adalah lastPage
                              child: Align(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.keyboard_arrow_right_rounded,
                                  color: white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
