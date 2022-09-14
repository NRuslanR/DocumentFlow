unit StandardDocumentKindWorkCycleInfoAppService;

interface

uses

  DocumentKindWorkCycleInfoAppService,
  DocumentKindWorkCycleInfoDto,
  AbstractApplicationService,
  DocumentKindWorkCycleInfoService,
  DocumentKinds,
  DocumentKindWorkCycleInfo,
  DocumentKindsMapper,
  DocumentKindFinder,
  DocumentWorkCycle,
  SysUtils,
  Classes;

type

  TStandardDocumentKindWorkCycleInfoAppService =
    class (TAbstractApplicationService, IDocumentKindWorkCycleInfoAppService)

      private

        FDocumentKindWorkCycleInfoService: IDocumentKindWorkCycleInfoService;

        FDocumentKindsMapper: TDocumentKindsMapper;

        function MapDocumentKindWorkCycleInfoDtoFrom(
          DocumentKindWorkCycleInfo: TDocumentKindWorkCycleInfo
        ): TDocumentKindWorkCycleInfoDto;

        procedure FillDocumentWorkCycleStageInfoDtosFrom(
          DocumentKindWorkCycleInfoDto: TDocumentKindWorkCycleInfoDto;
          DocumentWorkCycle: TDocumentWorkCycle
        );

        procedure FillDocumentWorkCycleStageInfoDtoFrom(
          DocumentWorkCycleStageInfoDto: TDocumentKindWorkCycleStageInfoDto;
          DocumentWorkCycleStage: TDocumentWorkCycleStage
        );

      public

        destructor Destroy; override;
        
        constructor Create(
          DocumentKindWorkCycleInfoService: IDocumentKindWorkCycleInfoService
        );

        function GetDocumentKindWorkCycleInfo(
          const DocumentKind: TDocumentKindClass
        ): TDocumentKindWorkCycleInfoDto;

        function GetDocumentKindWorkCycleInfos(
          const DocumentKinds:  array of TDocumentKindClass
        ): TDocumentKindWorkCycleInfoDtos;

        function GetAllDocumentKindWorkCycleInfos: TDocumentKindWorkCycleInfoDtos;
        
    end;
  
implementation

uses

  IDomainObjectBaseListUnit,
  IDomainObjectBaseUnit;

{ TStandardDocumentKindWorkCycleInfoAppService }

constructor TStandardDocumentKindWorkCycleInfoAppService.Create(
  DocumentKindWorkCycleInfoService: IDocumentKindWorkCycleInfoService
);
begin

  inherited Create;

  FDocumentKindWorkCycleInfoService := DocumentKindWorkCycleInfoService;

  FDocumentKindsMapper := TDocumentKindsMapper.Create;

end;

destructor TStandardDocumentKindWorkCycleInfoAppService.Destroy;
begin

  FreeAndNil(FDocumentKindsMapper);
  
  inherited;

end;

procedure TStandardDocumentKindWorkCycleInfoAppService.
  FillDocumentWorkCycleStageInfoDtoFrom(
    DocumentWorkCycleStageInfoDto: TDocumentKindWorkCycleStageInfoDto;
    DocumentWorkCycleStage: TDocumentWorkCycleStage
  );
begin

  if Assigned(DocumentWorkCycleStage) then begin

    DocumentWorkCycleStageInfoDto.StageNumber := DocumentWorkCycleStage.Number;
    DocumentWorkCycleStageInfoDto.StageName := DocumentWorkCycleStage.Name;

  end

  else begin

    DocumentWorkCycleStageInfoDto.StageNumber := -1;
    DocumentWorkCycleStageInfoDto.StageName := '';
    
  end;

end;

procedure TStandardDocumentKindWorkCycleInfoAppService.
  FillDocumentWorkCycleStageInfoDtosFrom(
    DocumentKindWorkCycleInfoDto: TDocumentKindWorkCycleInfoDto;
    DocumentWorkCycle: TDocumentWorkCycle
  );
begin

  with DocumentKindWorkCycleInfoDto, DocumentWorkCycle do begin

    FillDocumentWorkCycleStageInfoDtoFrom(
      DocumentCreatedStageInfo, StageOfDocumentCreated
    );

    FillDocumentWorkCycleStageInfoDtoFrom(
      DocumentApprovingStageInfo, StageOfDocumentApproving
    );

    FillDocumentWorkCycleStageInfoDtoFrom(
      DocumentApprovedStageInfo, StageOfDocumentApproved
    );

    FillDocumentWorkCycleStageInfoDtoFrom(
      DocumentNotApprovedStageInfo, StageOfDocumentNotApproved
    );

    FillDocumentWorkCycleStageInfoDtoFrom(
      DocumentSigningStageInfo, StageOfDocumentSigning
    );

    FillDocumentWorkCycleStageInfoDtoFrom(
      DocumentSigningRejectedStageInfo, StageOfDocumentSigningRejected
    );

    FillDocumentWorkCycleStageInfoDtoFrom(
      DocumentPerformingStageInfo, StageOfDocumentPerforming
    );

    FillDocumentWorkCycleStageInfoDtoFrom(
      DocumentPerformedStageInfo, StageOfDocumentPerformed
    );
    
  end;

end;

function TStandardDocumentKindWorkCycleInfoAppService.
  GetAllDocumentKindWorkCycleInfos: TDocumentKindWorkCycleInfoDtos;
var
    DocumentKindWorkCycleInfos: TDocumentKindWorkCycleInfos;
    DocumentKindWorkCycleInfo: TDocumentKindWorkCycleInfo;
    Free: IDomainObjectBaseList;
begin

  { refactor: to take document kind infos from db, map it to domain kinds and call an appropriate domain service }

  Result :=
    GetDocumentKindWorkCycleInfos(
      [
        TApproveableServiceNoteKind,
        TOutcomingServiceNoteKind,
        TIncomingServiceNoteKind,
        TPersonnelOrderKind
      ]
    );
    
end;

function TStandardDocumentKindWorkCycleInfoAppService.
  GetDocumentKindWorkCycleInfos(
    const DocumentKinds: array of TDocumentKindClass
  ): TDocumentKindWorkCycleInfoDtos;
var DocumentKindWorkCycleInfo: TDocumentKindWorkCycleInfo;
    DocumentKind: TDocumentKindClass;
begin

  Result := TDocumentKindWorkCycleInfoDtos.Create;

  try

    for DocumentKind in DocumentKinds do
      Result.Add(GetDocumentKindWorkCycleInfo(DocumentKind));

  except

    on E: Exception do begin

      FreeAndNil(Result);

      Raise;
      
    end;

  end;

end;

function TStandardDocumentKindWorkCycleInfoAppService.GetDocumentKindWorkCycleInfo(
  const DocumentKind: TDocumentKindClass
): TDocumentKindWorkCycleInfoDto;
var DocumentKindWorkCycleInfo: TDocumentKindWorkCycleInfo;
    Free: IDomainObjectBase;
begin

  DocumentKindWorkCycleInfo :=
    FDocumentKindWorkCycleInfoService.GetDocumentKindWorkCycleInfo(
      FDocumentKindsMapper.MapDocumentKindToDomainDocumentKind(DocumentKind)
    );

  Free := DocumentKindWorkCycleInfo;

  Result :=
    MapDocumentKindWorkCycleInfoDtoFrom(DocumentKindWorkCycleInfo);

  Result.DocumentKind := DocumentKind;
  
end;

function TStandardDocumentKindWorkCycleInfoAppService.
  MapDocumentKindWorkCycleInfoDtoFrom(
    DocumentKindWorkCycleInfo: TDocumentKindWorkCycleInfo
  ): TDocumentKindWorkCycleInfoDto;
begin

  Result := TDocumentKindWorkCycleInfoDto.Create;

  try

    Result.DocumentKind :=
      FDocumentKindsMapper.MapDomainDocumentKindToDocumentKind(
        DocumentKindWorkCycleInfo.DocumentKind
      );

    FillDocumentWorkCycleStageInfoDtosFrom(
      Result, DocumentKindWorkCycleInfo.DocumentWorkCycle
    );

  except

    on E: Exception do begin

      FreeAndNil(Result);

      Raise;

    end;

  end;
  
end;

end.
