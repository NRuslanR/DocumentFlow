unit LoodsmanDocumentUploadingStatus;

interface

uses

  SysUtils,
  Classes;

type

  TLoodsmanDocumentUploadingStatus = (
    usNotUploaded,
    usUploadingRequested,
    usUploading,
    usCancelationRequested,
    usCanceling,
    usCanceled,
    usUploaded,
    usUnknown
  );

  TLoodsmanDocumentUploadingStatusNames = class sealed

    public

      const

        NOT_UPLOADED_STATUS_NAME = 'Не выгружен';
        UPLOADING_REQUESTED_STATUS_NAME = 'Выгрузка запрошена';
        UPLOADING_STATUS_NAME = 'Выгружается';
        CANCELATION_REQUESTED_STATUS_NAME = 'Отмена выгрузки запрошена';
        CANCELING_STATUS_NAME = 'Выгрузка отменяется';
        CANCELED_STATUS_NAME = 'Выгрузка отменена';
        UPLOADED_STATUS_NAME = 'Выгружен';
        UNKNOWN_STATUS_NAME = 'Неизвестный статус';

      class function GetNameByStatus(const Status: TLoodsmanDocumentUploadingStatus): String; static;
      class function GetStatusNames: TStrings; static;

  end;

implementation

uses

  AuxiliaryStringFunctions;

{ TLoodsmanDocumentUploadingStatusNames }

class function TLoodsmanDocumentUploadingStatusNames.GetNameByStatus(
  const Status: TLoodsmanDocumentUploadingStatus): String;
begin

  case Status of

    usNotUploaded: Result := NOT_UPLOADED_STATUS_NAME;
    usUploadingRequested: Result := UPLOADING_REQUESTED_STATUS_NAME;
    usUploading: Result := UPLOADING_STATUS_NAME;
    usCancelationRequested: Result := CANCELATION_REQUESTED_STATUS_NAME;
    usCanceling: Result := CANCELING_STATUS_NAME;
    usCanceled: Result := CANCELED_STATUS_NAME;
    usUploaded: Result := UPLOADED_STATUS_NAME;

    else Result := UNKNOWN_STATUS_NAME;

  end;

end;

class function TLoodsmanDocumentUploadingStatusNames.GetStatusNames: TStrings;
begin

  Result :=
    CreateStringListFrom([
       TLoodsmanDocumentUploadingStatusNames.NOT_UPLOADED_STATUS_NAME,
       TLoodsmanDocumentUploadingStatusNames.UPLOADING_STATUS_NAME,
       TLoodsmanDocumentUploadingStatusNames.CANCELATION_REQUESTED_STATUS_NAME,
       TLoodsmanDocumentUploadingStatusNames.CANCELING_STATUS_NAME,
       TLoodsmanDocumentUploadingStatusNames.CANCELED_STATUS_NAME,
       TLoodsmanDocumentUploadingStatusNames.UPLOADED_STATUS_NAME,
       TLoodsmanDocumentUploadingStatusNames.UNKNOWN_STATUS_NAME
    ]);

end;

end.
