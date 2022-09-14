unit DocumentKindWorkCycleColors;

interface

uses

  UIDocumentKinds,
  StandardUIDocumentKindMapper,
  DocumentKindWorkCycleInfoDto,
  SysUtils,
  Graphics,
  Classes;

type

  TDocumentKindWorkCycleColors = class
      
    private

      FStandardUIDocumentKindMapper: TStandardUIDocumentKindMapper;
      FDocumentKindWorkCycleInfos: TDocumentKindWorkCycleInfoDtos;
      
    public

      destructor Destroy; override;
      
      constructor Create(
        DocumentKindWorkCycleInfos: TDocumentKindWorkCycleInfoDtos
      );

      function GetDocumentKindWorkCycleStageColor(
        const UIDocumentKind: TUIDocumentKindClass;
        const DocumentWorkCycleStageNumber: Integer
      ): TColor; overload;

      function GetDocumentKindWorkCycleStageColor(
        const UIDocumentKind: TUIDocumentKindClass;
        const DocumentWorkCycleStageName: String
      ): TColor; overload;

      function GetDocumentKindPerformedChargeSheetsColor(
        const UIDocumentKind: TUIDocumentKindClass
      ): TColor;

      function GetDocumentKindPerformedSubordinateChargeSheetsColor(
        const UIDocumentKind: TUIDocumentKindClass
      ): TColor;

      function GetDocumentKindNotPerformedChargeSheetsColor(
        UIDocumentKind: TUIDocumentKindClass
      ): TColor;
      
  end;

implementation

const

  DOCUMENT_PERFORMED_STAGE_COLOR = $0077ffda;
  DOCUMENT_PERFORMING_STAGE_COLOR = $0081e0ff;
  DOCUMENT_SIGNING_STAGE_COLOR = $008e99ff;
  DOCUMENT_SIGNING_REJECTED_STAGE_COLOR = $008e99ff;
  
{ TDocumentKindWorkCycleColors }

constructor TDocumentKindWorkCycleColors.Create(
  DocumentKindWorkCycleInfos: TDocumentKindWorkCycleInfoDtos);
begin

  inherited Create;

  FStandardUIDocumentKindMapper := TStandardUIDocumentKindMapper.Create;
  FDocumentKindWorkCycleInfos := DocumentKindWorkCycleInfos;
  
end;

destructor TDocumentKindWorkCycleColors.Destroy;
begin

  FreeAndNil(FStandardUIDocumentKindMapper);
  FreeAndNil(FDocumentKindWorkCycleInfos);
                            
  inherited;

end;

function TDocumentKindWorkCycleColors.
  GetDocumentKindWorkCycleStageColor(
    const UIDocumentKind: TUIDocumentKindClass;
    const DocumentWorkCycleStageNumber: Integer
  ): TColor;
var
    DocumentKindWorkCycleInfo: TDocumentKindWorkCycleInfoDto;
begin

  DocumentKindWorkCycleInfo :=
    FDocumentKindWorkCycleInfos.FindByDocumentKind(
      FStandardUIDocumentKindMapper.MapDocumentKindFrom(UIDocumentKind)
    );

  if not Assigned(DocumentKindWorkCycleInfo) then begin

    raise Exception.Create(
      'Программная ошибка. Не найдена ' +
      'информация о виде документов для ' +
      'определения цвета стадии рабочего ' +
      'цикла'
    );

  end;

  with DocumentKindWorkCycleInfo do begin

    if DocumentPerformingStageInfo.StageNumber = DocumentWorkCycleStageNumber
    then Result := DOCUMENT_PERFORMING_STAGE_COLOR

    else if DocumentPerformedStageInfo.StageNumber = DocumentWorkCycleStageNumber
    then Result := DOCUMENT_PERFORMED_STAGE_COLOR

    else if DocumentSigningStageInfo.StageNumber = DocumentWorkCycleStageNumber
    then Result := DOCUMENT_SIGNING_STAGE_COLOR

    else if DocumentSigningRejectedStageInfo.StageNumber = DocumentWorkCycleStageNumber
    then Result := DOCUMENT_SIGNING_REJECTED_STAGE_COLOR

    else Result := clDefault;

  end;

end;

function TDocumentKindWorkCycleColors.GetDocumentKindWorkCycleStageColor(
  const UIDocumentKind: TUIDocumentKindClass;
  const DocumentWorkCycleStageName: String
): TColor;
var
    DocumentKindWorkCycleInfo: TDocumentKindWorkCycleInfoDto;
begin

  DocumentKindWorkCycleInfo :=
    FDocumentKindWorkCycleInfos.FindByDocumentKind(
      FStandardUIDocumentKindMapper.MapDocumentKindFrom(UIDocumentKind)
    );

  if not Assigned(DocumentKindWorkCycleInfo) then begin

    raise Exception.Create(
      'Программная ошибка. Не найдена ' +
      'информация о виде документов для ' +
      'определения цвета стадии рабочего ' +
      'цикла'
    );

  end;

  with DocumentKindWorkCycleInfo do begin

    if DocumentPerformingStageInfo.StageName = DocumentWorkCycleStageName
    then Result := DOCUMENT_PERFORMING_STAGE_COLOR

    else if DocumentPerformedStageInfo.StageName = DocumentWorkCycleStageName
    then Result := DOCUMENT_PERFORMED_STAGE_COLOR

    else if DocumentSigningStageInfo.StageName = DocumentWorkCycleStageName
    then Result := DOCUMENT_SIGNING_STAGE_COLOR

    else if DocumentSigningRejectedStageInfo.StageName = DocumentWorkCycleStageName
    then Result := DOCUMENT_SIGNING_REJECTED_STAGE_COLOR

    else Result := clDefault;

  end;
  
end;

function TDocumentKindWorkCycleColors.
  GetDocumentKindNotPerformedChargeSheetsColor(
    UIDocumentKind: TUIDocumentKindClass
  ): TColor;
begin

  Result := $0081e0ff;

end;

function TDocumentKindWorkCycleColors.
  GetDocumentKindPerformedChargeSheetsColor(
    const UIDocumentKind: TUIDocumentKindClass
  ): TColor;
begin

  Result := $0077ffda;;
  
end;

function TDocumentKindWorkCycleColors.
  GetDocumentKindPerformedSubordinateChargeSheetsColor(
    const UIDocumentKind: TUIDocumentKindClass
  ): TColor;
begin

  Result := $00a5f0e6;

end;

end.
