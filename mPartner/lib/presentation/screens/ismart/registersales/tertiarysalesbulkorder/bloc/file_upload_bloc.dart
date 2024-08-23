import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../../../data/datasource/mpartner_remote_data_source.dart';
import '../../../../../../utils/enums.dart';

part 'file_upload_event.dart';
part 'file_upload_state.dart';

class FileUploadBloc extends Bloc<
    FileUploadEvent, FileUploadState> {
  final BaseMPartnerRemoteDataSource baseMPartnerRemoteDataSource;

  FileUploadBloc(this.baseMPartnerRemoteDataSource)
      : super(const FileUploadState()) {
    on<PostFileEvent>(postFileUploadEvent);
  }

  FutureOr<void> postFileUploadEvent(PostFileEvent event,
      Emitter<FileUploadState> emit) async {
    final result = await baseMPartnerRemoteDataSource
        .postTertiaryBulkPDFUpload(event.filePath,event.fileName);

    result.fold(
      (l) => emit(state.copyWith(
        fileUploadState: RequestState.error,
      )),
      (r) => emit(
        state.copyWith(
          isUploadedSuccessfully: r,
          fileUploadState: RequestState.loaded,
        ),
      ),
    );
  }
}
