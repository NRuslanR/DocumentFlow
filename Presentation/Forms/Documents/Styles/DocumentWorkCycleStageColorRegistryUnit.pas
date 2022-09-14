unit DocumentWorkCycleStageColorRegistryUnit;

interface

uses

  UIDocumentKinds,
  SysUtils,
  Graphics,
  Classes;

type

  TDocumentWorkCycleStageColorRegistry = class

    public

      class function GetColorForDocumentKindAndWorkCycleStage(
        UIDocumentKind: TUIDocumentKindClass;
        const DocumentWorkCycleStageNumber: Integer
      ): TColor;

  end;

implementation

uses

  DocumentWorkCycleStageInfoReferenceUnit;

const

  DOCUMENT_PERFORMED_STAGE_COLOR = $0077ffda;
  DOCUMENT_PERFORMING_STAGE_COLOR = $0081e0ff;
  DOCUMENT_SIGNING_STAGE_COLOR = $008e99ff;
  DOCUMENT_REJECTED_STAGE_COLOR = $008e99ff;
  
{ TDocumentWorkCycleStageColorRegistry }

class function TDocumentWorkCycleStageColorRegistry.
  GetColorForDocumentKindAndWorkCycleStage(
    UIDocumentKind: TUIDocumentKindClass;
    const DocumentWorkCycleStageNumber: Integer
  ): TColor;
begin

  if

    TDocumentWorkCycleStageInfoReference.
      GetSigningStageNumberForDocumentKind(UIDocumentKind) =
      DocumentWorkCycleStageNumber

  then Result := DOCUMENT_SIGNING_STAGE_COLOR

  else if

    TDocumentWorkCycleStageInfoReference.
      GetStageNumberOfRejectedForDocumentKind(UIDocumentKind) =
      DocumentWorkCycleStageNumber

  then Result := DOCUMENT_REJECTED_STAGE_COLOR

  else if

    TDocumentWorkCycleStageInfoReference.
      GetPerformingStageNumberForDocumentKind(UIDocumentKind) =
    DocumentWorkCycleStageNumber

  then Result := DOCUMENT_PERFORMING_STAGE_COLOR

  else if

    TDocumentWorkCycleStageInfoReference.
      GetStageNumberOfPerformedForDocumentKind(UIDocumentKind) =
      DocumentWorkCycleStageNumber

  then Result := DOCUMENT_PERFORMED_STAGE_COLOR

  else Result := clDefault;       

end;

end.
