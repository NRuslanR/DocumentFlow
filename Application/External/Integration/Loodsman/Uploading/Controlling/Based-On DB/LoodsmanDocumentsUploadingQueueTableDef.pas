unit LoodsmanDocumentsUploadingQueueTableDef;

interface

uses

  LoodsmanDocumentUploadingStatus,
  TableDef,
  SysUtils,
  Classes;

type

  TLoodsmanDocumentsUploadingQueueTableDef = class (TTableDef)

    const

        NOT_UPLOADED_STATUS_NAME = 'not_uploaded';
        UPLOADING_REQUESTED_STATUS_NAME = 'uploading_requested';
        UPLOADING_STATUS_NAME = 'uploading';
        CANCELATION_REQUESTED_STATUS_NAME = 'cancelation_requested';
        CANCELING_STATUS_NAME = 'canceling';
        CANCELED_STATUS_NAME = 'canceled';
        UPLOADED_STATUS_NAME = 'uploaded';
        UNKNOWN_STATUS_NAME = 'unknown';

    public

      InitiatorIdColumnName: String;
      DocumentIdColumnName: String;
      DocumentJsonColumnName: String;
      StatusColumnName: String;
      UploadingRequestedDateTimeColumnName: String;
      UploadingDateTimeColumnName: String;
      CancelerIdColumnName: String;
      CancelationRequestedDateTimeColumnName: String;
      CancelingDateTimeColumnName: String;
      CanceledDateTimeColumnName: String;
      UploadedDateTimeColumnName: String;
      ErrorMessageColumnName: String;

      function GetStatusInitiatorIdColumnNameByStatus(const Status: TLoodsmanDocumentUploadingStatus): String;
      function GetStatusDateTimeColumnNameByStatus(const Status: TLoodsmanDocumentUploadingStatus): String;
    
  end;
  
implementation

{ TLoodsmanDocumentsUploadingQueueTableDef }

function TLoodsmanDocumentsUploadingQueueTableDef
  .GetStatusDateTimeColumnNameByStatus(
    const Status: TLoodsmanDocumentUploadingStatus
  ): String;
begin

  case Status of

    usUploadingRequested: Result := UploadingRequestedDateTimeColumnName;
    usUploading: Result := UploadingDateTimeColumnName;
    usCancelationRequested: Result := CancelationRequestedDateTimeColumnName;
    usCanceling: Result := CancelingDateTimeColumnName;
    usCanceled: Result := CanceledDateTimeColumnName;
    usUploaded: Result := UploadedDateTimeColumnName;
    
    usNotUploaded, usUnknown: Result := '';

  end;

end;

function TLoodsmanDocumentsUploadingQueueTableDef.GetStatusInitiatorIdColumnNameByStatus(
  const Status: TLoodsmanDocumentUploadingStatus): String;
begin

  case Status of

    usUploadingRequested: Result := InitiatorIdColumnName;
    usCancelationRequested: Result := CancelerIdColumnName;

    else Result := '';
    
  end;

end;

end.
