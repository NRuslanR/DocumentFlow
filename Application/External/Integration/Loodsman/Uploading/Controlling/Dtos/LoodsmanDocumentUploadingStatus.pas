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

        NOT_UPLOADED_STATUS_NAME = '�� ��������';
        UPLOADING_REQUESTED_STATUS_NAME = '�������� ���������';
        UPLOADING_STATUS_NAME = '�����������';
        CANCELATION_REQUESTED_STATUS_NAME = '������ �������� ���������';
        CANCELING_STATUS_NAME = '�������� ����������';
        CANCELED_STATUS_NAME = '�������� ��������';
        UPLOADED_STATUS_NAME = '��������';
        UNKNOWN_STATUS_NAME = '����������� ������';

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
