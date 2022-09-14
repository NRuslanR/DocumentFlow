unit DocumentKindWorkCycleInfoDto;

interface

uses

  DocumentKinds,
  SysUtils,
  Classes;

type

  TDocumentKindWorkCycleStageInfoDto = class

    public

      StageNumber: Integer;
      StageName: String;
      
  end;

  TDocumentKindWorkCycleInfoDto = class

    public

      DocumentKind: TDocumentKindClass;

      DocumentCreatedStageInfo: TDocumentKindWorkCycleStageInfoDto;
      DocumentApprovingStageInfo: TDocumentKindWorkCycleStageInfoDto;
      DocumentApprovedStageInfo: TDocumentKindWorkCycleStageInfoDto;
      DocumentNotApprovedStageInfo: TDocumentKindWorkCycleStageInfoDto;
      DocumentSigningStageInfo: TDocumentKindWorkCycleStageInfoDto;
      DocumentSigningRejectedStageInfo: TDocumentKindWorkCycleStageInfoDto;
      DocumentPerformingStageInfo: TDocumentKindWorkCycleStageInfoDto;
      DocumentPerformedStageInfo: TDocumentKindWorkCycleStageInfoDto;

      destructor Destroy; override;
      
      constructor Create;

  end;

  TDocumentKindWorkCycleInfoDtos = class;

  TDocumentKindWorkCycleInfoDtosEnumerator = class (TListEnumerator)

    private

      function GetCurrentDocumentKindWorkCycleInfoDto:
        TDocumentKindWorkCycleInfoDto;

    public

      constructor Create(
        DocumentKindWorkCycleInfoDtos: TDocumentKindWorkCycleInfoDtos
      );

      property Current: TDocumentKindWorkCycleInfoDto
      read GetCurrentDocumentKindWorkCycleInfoDto;
      
  end;

  TDocumentKindWorkCycleInfoDtos = class (TList)

    private

      function GetDocumentKindWorkCycleInfoDtoByIndex(
        Index: Integer
      ): TDocumentKindWorkCycleInfoDto;

      procedure SetDocumentKindWorkCycleInfoDtoByIndex(
        Index: Integer;
        const Value: TDocumentKindWorkCycleInfoDto
      );
    
    public

      function Add(
        DocumentKindWorkCycleInfoDto: TDocumentKindWorkCycleInfoDto
      ): Integer;

      function FindByDocumentKind(DocumentKind: TDocumentKindClass): TDocumentKindWorkCycleInfoDto;

      function GetEnumerator: TDocumentKindWorkCycleInfoDtosEnumerator;

      property Items[Index: Integer]: TDocumentKindWorkCycleInfoDto
      read GetDocumentKindWorkCycleInfoDtoByIndex
      write SetDocumentKindWorkCycleInfoDtoByIndex;
      
  end;
  
implementation

{ TDocumentKindWorkCycleInfoDto }

constructor TDocumentKindWorkCycleInfoDto.Create;
begin

  inherited;

  DocumentCreatedStageInfo := TDocumentKindWorkCycleStageInfoDto.Create;
  DocumentApprovingStageInfo := TDocumentKindWorkCycleStageInfoDto.Create;
  DocumentApprovedStageInfo := TDocumentKindWorkCycleStageInfoDto.Create;
  DocumentNotApprovedStageInfo := TDocumentKindWorkCycleStageInfoDto.Create;
  DocumentSigningStageInfo := TDocumentKindWorkCycleStageInfoDto.Create;
  DocumentSigningRejectedStageInfo := TDocumentKindWorkCycleStageInfoDto.Create;
  DocumentPerformingStageInfo := TDocumentKindWorkCycleStageInfoDto.Create;
  DocumentPerformedStageInfo := TDocumentKindWorkCycleStageInfoDto.Create;

end;

destructor TDocumentKindWorkCycleInfoDto.Destroy;
begin

  FreeAndNil(DocumentCreatedStageInfo);
  FreeAndNil(DocumentApprovingStageInfo);
  FreeAndNil(DocumentApprovedStageInfo);
  FreeAndNil(DocumentNotApprovedStageInfo);
  FreeAndNil(DocumentSigningStageInfo);
  FreeAndNil(DocumentSigningRejectedStageInfo);
  FreeAndNil(DocumentPerformingStageInfo);
  FreeAndNil(DocumentPerformedStageInfo);

  inherited;

end;

{ TDocumentKindWorkCycleInfoDtos }

function TDocumentKindWorkCycleInfoDtos.Add(
  DocumentKindWorkCycleInfoDto: TDocumentKindWorkCycleInfoDto): Integer;
begin

  Result := inherited Add(DocumentKindWorkCycleInfoDto);

end;

function TDocumentKindWorkCycleInfoDtos.FindByDocumentKind(
  DocumentKind: TDocumentKindClass
): TDocumentKindWorkCycleInfoDto;
begin

  for Result in Self do
    if Result.DocumentKind = DocumentKind then
      Exit;

  Result := nil;

end;

function TDocumentKindWorkCycleInfoDtos.GetDocumentKindWorkCycleInfoDtoByIndex(
  Index: Integer): TDocumentKindWorkCycleInfoDto;
begin

  Result := TDocumentKindWorkCycleInfoDto(Get(Index));

end;

function TDocumentKindWorkCycleInfoDtos.
  GetEnumerator: TDocumentKindWorkCycleInfoDtosEnumerator;
begin

  Result := TDocumentKindWorkCycleInfoDtosEnumerator.Create(Self);
  
end;

procedure TDocumentKindWorkCycleInfoDtos.SetDocumentKindWorkCycleInfoDtoByIndex(
  Index: Integer; const Value: TDocumentKindWorkCycleInfoDto);
begin

  Put(Index, Value);
  
end;

{ TDocumentKindWorkCycleInfoDtosEnumerator }

constructor TDocumentKindWorkCycleInfoDtosEnumerator.Create(
  DocumentKindWorkCycleInfoDtos: TDocumentKindWorkCycleInfoDtos);
begin

  inherited Create(DocumentKindWorkCycleInfoDtos);
  
end;

function TDocumentKindWorkCycleInfoDtosEnumerator.
  GetCurrentDocumentKindWorkCycleInfoDto: TDocumentKindWorkCycleInfoDto;
begin

  Result := TDocumentKindWorkCycleInfoDto(GetCurrent);
  
end;

end.
