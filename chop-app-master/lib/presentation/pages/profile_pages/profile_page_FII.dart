// profile_page_vendor.dart
import 'package:chop/core/components/Loading.dart';
import 'package:chop/di.dart';
import 'package:chop/presentation/pages/profile_pages/cubit/profile_pages_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../domain/model/user.dart';

class ProfilePageFII extends StatelessWidget {
  final User fii;

  const ProfilePageFII({Key? key, required this.fii}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProfilePagesCubit>(),
      child: BlocConsumer<ProfilePagesCubit, ProfilePagesState>(
        listener: (context, state) {
          if (state is ProfilePagesLogOut) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/login', (route) => false);
          }
        },
        builder: (context, state) {
          if (state is ProfilePageLoading) return loadingWidget(context);
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name',
                        style: GoogleFonts.inriaSans(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        fii.name,
                        style: GoogleFonts.inriaSans(fontSize: 16.0),
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        'Email',
                        style: GoogleFonts.inriaSans(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        fii.email,
                        style: GoogleFonts.inriaSans(fontSize: 16.0),
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        'Phone',
                        style: GoogleFonts.inriaSans(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        fii.phone,
                        style: GoogleFonts.inriaSans(fontSize: 16.0),
                      ),
                      const Expanded(child: SizedBox()),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 40,
                        child: Row(
                          children: [
                            const Expanded(child: SizedBox()),
                            ElevatedButton(
                                onPressed: () =>
                                    BlocProvider.of<ProfilePagesCubit>(context)
                                        .logOut(),
                                child: const Text('Log out',
                                    style: TextStyle(color: Colors.white))),
                          ],
                        ),
                      )
                    ],
                  ),
                  const Expanded(child: SizedBox())
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
