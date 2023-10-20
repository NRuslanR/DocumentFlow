unit LoodsmanDocumentUploadingStatusChangingEnsurer;

interface

uses

  LoodsmanDocumentUploadingInfo,
  LoodsmanDocumentUploadingStatus,
  SysUtils,
  Classes;

type

  TLoodsmanDocumentUploadingStatusChangingEnsurerException = class (Exception)

  end;

  ILoodsmanDocumentUploadingStatusChangingEnsurer = interface

    procedure EnsureDocumentUploadingStatusChangingAllowed(
      UploadingInfo: TLoodsmanDocumentUploadingInfo;
      const NewStatus: TLoodsmanDocumentUploadingStatus
    );

  end;

implementation

end.
