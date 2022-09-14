unit StandardDocumentApprovingListCreatingAppService;

interface

uses

  DocumentApprovingListDTO,
  DocumentApprovingList,
  DocumentApprovingListCreatingAppService,
  DocumentApprovingListCreatingService,
  DocumentApprovingCycleResult,
  AbstractApplicationService,
  DocumentFlowEmployeeInfoDTO,
  DocumentFlowEmployeeInfoDTOMapper,
  SysUtils,
  Classes;

type

  TStandardDocumentApprovingListCreatingAppService =
    class (
      TAbstractApplicationService,
      IDocumentApprovingListCreatingAppService
    )

      protected

        FDocumentApprovingListCreatingService: IDocumentApprovingListCreatingService;

        FDocumentFlowEmployeeInfoDTOMapper: TDocumentFlowEmployeeInfoDTOMapper;
        
        function MapDocumentApprovingListDTOsFrom(
          DocumentApprovingLists: TDocumentApprovingLists
        ): TDocumentApprovingListDTOs; virtual;

        function MapDocumentApprovingListDTOFrom(
          ApprovingList: TDocumentApprovingList
        ): TDocumentApprovingListDTO; virtual;
        
        function MapDocumentApprovingListRecordDTOsFrom(
          DocumentApprovingListRecords: TDocumentApprovingListRecords
        ): TDocumentApprovingListRecordDTOs; virtual;

        function MapDocumentApprovingListRecordDTOFrom(
          DocumentApprovingListRecord: TDocumentApprovingListRecord
        ): TDocumentApprovingListRecordDTO; virtual;

      public        
        
        constructor Create(
          DocumentApprovingListCreatingService: IDocumentApprovingListCreatingService;
          DocumentFlowEmployeeInfoDTOMapper: TDocumentFlowEmployeeInfoDTOMapper
        );

        function CreateDocumentApprovingListsForDocument(
          const DocumentId: Variant
        ): TDocumentApprovingListDTOs; virtual;

    end;
    
implementation

uses

  DocumentApprovings,
  IDomainObjectBaseListUnit,
  IDomainObjectValueUnit,
  IDomainObjectValueListUnit,
  DomainException;
  
{ TStandardDocumentApprovingListCreatingAppService }

constructor TStandardDocumentApprovingListCreatingAppService.Create(
  DocumentApprovingListCreatingService: IDocumentApprovingListCreatingService;
  DocumentFlowEmployeeInfoDTOMapper: TDocumentFlowEmployeeInfoDTOMapper
);
begin

  inherited Create;

  FDocumentApprovingListCreatingService := DocumentApprovingListCreatingService;
  FDocumentFlowEmployeeInfoDTOMapper := DocumentFlowEmployeeInfoDTOMapper;
  
end;

function TStandardDocumentApprovingListCreatingAppService.
  CreateDocumentApprovingListsForDocument(
    const DocumentId: Variant
  ): TDocumentApprovingListDTOs;

var
    DocumentApprovingLists: TDocumentApprovingLists;
    FreeDocumentApprovingLists: IDomainObjectValueList;
begin

  try

    DocumentApprovingLists :=
      FDocumentApprovingListCreatingService.
        CreateDocumentApprovingLists(DocumentId);

    if not Assigned(DocumentApprovingLists) then begin

      Result := nil;
      Exit;

    end;

    FreeDocumentApprovingLists := DocumentApprovingLists;

    Result := MapDocumentApprovingListDTOsFrom(DocumentApprovingLists);

  except

    on e: Exception do begin

      if e is TDomainException then
        RaiseApplicationServiceException(e.Message)

      else Raise;

    end;

  end;

end;

function TStandardDocumentApprovingListCreatingAppService.
  MapDocumentApprovingListDTOsFrom(
    DocumentApprovingLists: TDocumentApprovingLists
  ): TDocumentApprovingListDTOs;
var
    DocumentApprovingList: TDocumentApprovingList;
begin

  Result := TDocumentApprovingListDTOs.Create;

  try

    for DocumentApprovingList in DocumentApprovingLists do
      Result.Add(MapDocumentApprovingListDTOFrom(DocumentApprovingList));

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

function TStandardDocumentApprovingListCreatingAppService.MapDocumentApprovingListDTOFrom(
  ApprovingList: TDocumentApprovingList): TDocumentApprovingListDTO;
begin

  Result := TDocumentApprovingListDTO.Create;

  try

    Result.Title := ApprovingList.Title;

    case ApprovingList.Kind of

      DocumentApprovingList.alkApproving:
        Result.Kind := DocumentApprovingListDTO.alkApproving;

      DocumentApprovingList.alkViseing:
        Result.Kind := DocumentApprovingListDTO.alkViseing;

    end;
    
    Result.Records :=
      MapDocumentApprovingListRecordDTOsFrom(ApprovingList.Records);
    
  except

    FreeAndNil(Result);

    Raise;

  end;

end;


function TStandardDocumentApprovingListCreatingAppService.
  MapDocumentApprovingListRecordDTOsFrom(
    DocumentApprovingListRecords: TDocumentApprovingListRecords
  ): TDocumentApprovingListRecordDTOs;
var DocumentApprovingListRecord: TDocumentApprovingListRecord;
begin

  Result := TDocumentApprovingListRecordDTOs.Create;

  try

    for DocumentApprovingListRecord in DocumentApprovingListRecords do
      Result.Add(MapDocumentApprovingListRecordDTOFrom(DocumentApprovingListRecord));

  except

    on e: Exception do begin

      FreeAndNil(Result);
      raise;
      
    end;

  end;
    
end;

function TStandardDocumentApprovingListCreatingAppService.
  MapDocumentApprovingListRecordDTOFrom(
    DocumentApprovingListRecord: TDocumentApprovingListRecord
  ): TDocumentApprovingListRecordDTO;
begin

  Result := TDocumentApprovingListRecordDTO.Create;

  try

    Result.ApproverDTO :=
      FDocumentFlowEmployeeInfoDTOMapper.MapDocumentFlowEmployeeInfoDTOFrom(
        DocumentApprovingListRecord.Approver
      );

    case DocumentApprovingListRecord.ApprovingPerformingResult of

      prApproved:

        Result.ApprovingPerformingResultDTO := DocumentApproved;

      prRejected:

        Result.ApprovingPerformingResultDTO := DocumentNotApproved;

      prNotPerformed:

        Result.ApprovingPerformingResultDTO := DocumentApprovingNotPerformed;

    end;
    
  except

    on e: Exception do begin

      FreeAndNil(Result);
      raise;
      
    end;

  end;

end;

end.
