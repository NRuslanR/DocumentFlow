unit DocumentChargesFormViewModelMapper;

interface

uses

  DocumentFullInfoDTO,
  DepartmentInfoDTO,
  DocumentFlowEmployeeInfoDTO,
  ChangedDocumentInfoDTO,
  DocumentChargeSheetsInfoDTO,
  DocumentChargesFormViewModelUnit,
  DocumentChargeSetHolder,
  DocumentChargeKindsControlAppService,
  DocumentDataSetHoldersFactory,
  SysUtils,
  Classes,
  DB;

type

  { refactor(DocumentChargesFormViewModelMapper, 1):
    в зависимости от того, является
    документ входящим или исходящим
    метод MapDocumentChargesFormViewModelTo может
    возвращать либо объект TDocumentChargesChangesInfoDTO,
    либо объект TDocumentChargeSheetsChangesInfoDTO (для
    входящего док-а). Обратное отображение ViewModel'и
    в DTO применяется для фиксации изменений в
    хранилище данных (БД) через DTO. Поскольку входящий документ
    не может редактироваться, поэтому на данный момент возвращается
    TDocumentChargesChangesInfoDTO. Рекомендуется
    сделать отдельные мапперы для
    TDocumentChargesChangesInfoDTO и
    TDocumentChargeSheetChangesInfoDTO для обычного док-а (исходящего)
    и входящего соответственно. И затем составлять
    DocumentCardFormViewModelMapper'ы отдельно для исходящего и
    входящего док-ов из одинаковых мапперов, кроме
    Mapper'ов, отображающих поручения и листы поручений.
  }
  {
    refactor(DocumentChargesFormViewModelMapper, 2):
    в соответствии с изменённым функционалом поручений
    изменить данный маппер. Сделать отдельный маппер
    на каждый тип поручения
  }

  TDocumentChargesFormViewModelMapper = class

    protected

      FDocumentChargeKindsControlAppService: IDocumentChargeKindsControlAppService;
      
    protected

      function CreateDocumentChargesFormViewModelInstance:
        TDocumentChargesFormViewModel; virtual;

    protected

      procedure FillDocumentChargeSetHolderFrom(
        DocumentChargeSetHolder: TDocumentChargeSetHolder;
        DocumentDTO: TDocumentDTO;
        DocumentChargesInfoDTO: TDocumentChargesInfoDTO
      ); overload;

      procedure FillDocumentChargeSetHolderFrom(
        DocumentChargeSetHolder: TDocumentChargeSetHolder;
        DocumentChargeSheetsInfoDTO: TDocumentChargeSheetsInfoDTO
      ); overload;

    protected

      function MapDocumentChargeSetHolderToChargesInfoDTO(
        DocumentChargesFormViewModel: TDocumentChargesFormViewModel
      ): TDocumentChargesInfoDTO;

      function MapDocumentChargesFormViewModelToAddedChargesInfoDTO(
        DocumentChargesFormViewModel: TDocumentChargesFormViewModel
      ): TDocumentChargesInfoDTO;

      function MapDocumentChargesFormViewModelToChangedChargesInfoDTO(
        DocumentChargesFormViewModel: TDocumentChargesFormViewModel
      ): TDocumentChargesInfoDTO;

      function MapDocumentChargesFormViewModelToRemovedChargesInfoDTO(
        DocumentChargesFormViewModel: TDocumentChargesFormViewModel
      ): TDocumentChargesInfoDTO;

    public

      constructor Create(DocumentChargeKindsControlAppService: iDocumentChargeKindsControlAppService);
      
      function MapDocumentChargesFormViewModelFrom(
        DocumentDTO: TDocumentDTO;
        DocumentChargesInfoDTO: TDocumentChargesInfoDTO;
        DocumentChargeSheetsInfoDTO: TDocumentChargeSheetsInfoDTO;
        DocumentChargeSetHolder: TDocumentChargeSetHolder
      ): TDocumentChargesFormViewModel; virtual;

      function MapDocumentChargesFormViewModelToChargeChangesInfoDTO(
        DocumentChargesFormViewModel: TDocumentChargesFormViewModel
      ): TDocumentChargesChangesInfoDTO; virtual;

      function MapDocumentChargesFormViewModelToNewChargesInfoDTO(
        DocumentChargesFormViewModel: TDocumentChargesFormViewModel
      ): TDocumentChargesInfoDTO; virtual;

      function CreateEmptyDocumentChargesFormViewModel(
        DocumentChargeSetHolder: TDocumentChargeSetHolder;
        const DocumentKindId: Variant { refactor: delete, view unDocumentCardListFrame.OnNewDocumentCreatingRequestedEventHandler }
      ): TDocumentChargesFormViewModel; virtual;

  end;
  
implementation

uses

  Variants;
  
{ TDocumentChargesFormViewModelMapper }

function TDocumentChargesFormViewModelMapper.
  MapDocumentChargesFormViewModelFrom(
    DocumentDTO: TDocumentDTO;
    DocumentChargesInfoDTO: TDocumentChargesInfoDTO;
    DocumentChargeSheetsInfoDTO: TDocumentChargeSheetsInfoDTO;
    DocumentChargeSetHolder: TDocumentChargeSetHolder
  ): TDocumentChargesFormViewModel;
  
var
    DocumentChargeInfoDTO: TDocumentChargeInfoDTO;
    DocumentChargeSheetInfoDTO: TDocumentChargeSheetInfoDTO;
begin

  Result := CreateDocumentChargesFormViewModelInstance;

  if
    Assigned(DocumentChargeSheetsInfoDTO) and
    (DocumentChargeSheetsInfoDTO.Count > 0)
  then begin

    FillDocumentChargeSetHolderFrom(
      DocumentChargeSetHolder,
      DocumentChargeSheetsInfoDTO
    )

  end

  else if
    Assigned(DocumentChargesInfoDTO) and (DocumentChargesInfoDTO.Count > 0)
  then begin

    FillDocumentChargeSetHolderFrom(
      DocumentChargeSetHolder,
      DocumentDTO,
      DocumentChargesInfoDTO
    );

  end;

  Result.DocumentChargeSetHolder := DocumentChargeSetHolder;

  Result.DocumentChargeKindDto :=
    FDocumentChargeKindsControlAppService
      .FindMainDocumentChargeKindForDocumentKind(DocumentDTO.KindId);
    
end;

function TDocumentChargesFormViewModelMapper.
  MapDocumentChargesFormViewModelToChargeChangesInfoDTO(
    DocumentChargesFormViewModel: TDocumentChargesFormViewModel
  ): TDocumentChargesChangesInfoDTO;
begin

  try

    Result := TDocumentChargesChangesInfoDTO.Create;
    
    Result.AddedDocumentChargesInfoDTO :=
      MapDocumentChargesFormViewModelToAddedChargesInfoDTO(
        DocumentChargesFormViewModel
      );

    Result.ChangedDocumentChargesInfoDTO :=
      MapDocumentChargesFormViewModelToChangedChargesInfoDTO(
        DocumentChargesFormViewModel
      );

    Result.RemovedDocumentChargesInfoDTO :=
      MapDocumentChargesFormViewModelToRemovedChargesInfoDTO(
        DocumentChargesFormViewModel
      );

    DocumentChargesFormViewModel.
      DocumentChargeSetHolder.
        RevealNonRemovedChargeRecords

  except

    on e: Exception do begin

      FreeAndNil(Result);
      raise;

    end;

  end;

end;

function TDocumentChargesFormViewModelMapper.
  MapDocumentChargesFormViewModelToNewChargesInfoDTO(
    DocumentChargesFormViewModel: TDocumentChargesFormViewModel
  ): TDocumentChargesInfoDTO;
begin

  Result :=
    MapDocumentChargesFormViewModelToAddedChargesInfoDTO(
      DocumentChargesFormViewModel
    );

end;

procedure TDocumentChargesFormViewModelMapper.
  FillDocumentChargeSetHolderFrom(
    DocumentChargeSetHolder: TDocumentChargeSetHolder;
    DocumentDTO: TDocumentDTO;
    DocumentChargesInfoDTO: TDocumentChargesInfoDTO
  );
var DocumentChargeInfoDTO: TDocumentChargeInfoDTO;
begin

  with DocumentChargeSetHolder do begin

    for DocumentChargeInfoDTO in DocumentChargesInfoDTO do begin

      Append;

      IsChargeForAcquaitanceFieldValue := DocumentChargeInfoDTO.IsForAcquaitance;

      if not VarIsNull(DocumentChargeInfoDTO.Id) then
        IdFieldValue := DocumentChargeInfoDTO.Id;

      ChargeKindIdFieldValue := DocumentChargeInfoDTO.KindId;

      ChargeKindNameFieldValue := DocumentChargeInfoDTO.KindName;

      ChargeKindServiceNameFieldValue := DocumentChargeInfoDTO.ServiceKindName;

      TopLevelChargeIdFieldValue := Null;

      ReceiverFullNameFieldValue := DocumentChargeInfoDTO.PerformerInfoDTO.FullName;

      ReceiverSpecialityFieldValue := DocumentChargeInfoDTO.PerformerInfoDTO.Speciality;

      ReceiverIdFieldValue := DocumentChargeInfoDTO.PerformerInfoDTO.Id;

      ReceiverDepartmentNameFieldValue := DocumentChargeInfoDTO.PerformerInfoDTO.DepartmentInfoDTO.Name;

      ReceiverCommentFieldValue := DocumentChargeInfoDTO.PerformerResponse;

      ReceiverPerformingDateTimeFieldValue := DocumentChargeInfoDTO.PerformingDateTime;

      ReceiverDocumentIdFieldValue := DocumentDTO.Id;

      IsPerformedByReceiverFieldValue := not VarIsNull(DocumentChargeInfoDTO.PerformingDateTime);

      ChargeTextFieldValue := DocumentChargeInfoDTO.ChargeText;

      ReceiverLeaderIdFieldValue := DocumentChargeInfoDTO.PerformerInfoDTO.LeaderId;

      IsReceiverForeignFieldValue := DocumentChargeInfoDTO.PerformerInfoDTO.IsForeign;

      IsAccessibleChargeFieldValue := False;

      if Assigned(DocumentChargeInfoDTO.ActuallyPerformedEmployeeInfoDTO)
      then begin

        DocumentChargeSetHolder.PerformedChargeEmployeeNameFieldValue :=
          DocumentChargeInfoDTO.ActuallyPerformedEmployeeInfoDTO.FullName;

      end;

      MarkCurrentChargeRecordAsNonChanged;
      
      Post;

    end;

  end;

end;

function TDocumentChargesFormViewModelMapper.
  CreateEmptyDocumentChargesFormViewModel(
    DocumentChargeSetHolder: TDocumentChargeSetHolder;
    const DocumentKindId: Variant
  ): TDocumentChargesFormViewModel;
begin

  Result := CreateDocumentChargesFormViewModelInstance;

  Result.DocumentChargeSetHolder := DocumentChargeSetHolder;

  Result.DocumentChargeKindDto :=
    FDocumentChargeKindsControlAppService
      .FindMainDocumentChargeKindForDocumentKind(DocumentKindId);
    
end;

procedure TDocumentChargesFormViewModelMapper.
  FillDocumentChargeSetHolderFrom(
    DocumentChargeSetHolder: TDocumentChargeSetHolder;
    DocumentChargeSheetsInfoDTO: TDocumentChargeSheetsInfoDTO
  );
var DocumentChargeSheetInfoDTO: TDocumentChargeSheetInfoDTO;
begin

  with DocumentChargeSetHolder do begin

    for DocumentChargeSheetInfoDTO in DocumentChargeSheetsInfoDTO do begin

      Append;

      IdFieldValue := DocumentChargeSheetInfoDTO.Id;

      ChargeKindIdFieldValue := DocumentChargeSheetInfoDTO.KindId;

      ChargeKindNameFieldValue := DocumentChargeSheetInfoDTO.KindName;

      ChargeKindServiceNameFieldValue := DocumentChargeSheetInfoDTO.ServiceKindName;

      IsChargeForAcquaitanceFieldValue := DocumentChargeSheetInfoDTO.IsForAcquaitance;

      TopLevelChargeIdFieldValue := DocumentChargeSheetInfoDTO.TopLevelChargeSheetId;

      ReceiverFullNameFieldValue := DocumentChargeSheetInfoDTO.PerformerInfoDTO.FullName;

      ReceiverSpecialityFieldValue := DocumentChargeSheetInfoDTO.PerformerInfoDTO.Speciality;

      ReceiverIdFieldValue := DocumentChargeSheetInfoDTO.PerformerInfoDTO.Id;

      ReceiverDepartmentNameFieldValue := DocumentChargeSheetInfoDTO.PerformerInfoDTO.DepartmentInfoDTO.Name;

      ReceiverCommentFieldValue := DocumentChargeSheetInfoDTO.PerformerResponse;

      ReceiverPerformingDateTimeFieldValue := DocumentChargeSheetInfoDTO.PerformingDateTime;

      ReceiverDocumentIdFieldValue := DocumentChargeSheetInfoDTO.DocumentId;

      DocumentChargeSetHolder.IsPerformedByReceiverFieldValue :=
        not VarIsNull(DocumentChargeSheetInfoDTO.PerformingDateTime);

      ChargeTextFieldValue := DocumentChargeSheetInfoDTO.ChargeText;

      ReceiverLeaderIdFieldValue := DocumentChargeSheetInfoDTO.PerformerInfoDTO.LeaderId;

      IsReceiverForeignFieldValue := DocumentChargeSheetInfoDTO.PerformerInfoDTO.IsForeign;

      ViewingDateByPerformerFieldValue := DocumentChargeSheetInfoDTO.ViewingDateByPerformer;

      { refactor: to turn viewmodel's property to a few properties
        each of which will correspond to the acess right }
        
      IsAccessibleChargeFieldValue :=
        DocumentChargeSheetInfoDTO.AccessRights.PerformingAllowed;

      ReceiverRoleIdFieldValue := DocumentChargeSheetInfoDTO.PerformerInfoDTO.RoleId;

      ChargeSheetSenderEmployeeNameFieldValue := DocumentChargeSheetInfoDTO.SenderEmployeeInfoDTO.FullName;

      ChargeSheetSenderEmployeeIdFieldValue := DocumentChargeSheetInfoDTO.SenderEmployeeInfoDTO.Id;

      ChargeSheetIssuingDateTimeFieldValue := DocumentChargeSheetInfoDTO.IssuingDateTime;
      
      if Assigned(DocumentChargeSheetInfoDTO.ActuallyPerformedEmployeeInfoDTO)
      then begin

        PerformedChargeEmployeeNameFieldValue :=
          DocumentChargeSheetInfoDTO.ActuallyPerformedEmployeeInfoDTO.FullName;

      end;

      Post;

      MarkCurrentChargeRecordAsNonChanged;

    end;

  end;

end;

constructor TDocumentChargesFormViewModelMapper.Create(
  DocumentChargeKindsControlAppService: IDocumentChargeKindsControlAppService);
begin

  inherited Create;

  FDocumentChargeKindsControlAppService := DocumentChargeKindsControlAppService;
  
end;

function TDocumentChargesFormViewModelMapper.
  CreateDocumentChargesFormViewModelInstance: TDocumentChargesFormViewModel;
begin

  Result := TDocumentChargesFormViewModel.Create;

end;

function TDocumentChargesFormViewModelMapper.
  MapDocumentChargesFormViewModelToAddedChargesInfoDTO(
    DocumentChargesFormViewModel: TDocumentChargesFormViewModel
  ): TDocumentChargesInfoDTO;
begin

  DocumentChargesFormViewModel.
    DocumentChargeSetHolder.
      RevealAddedChargeRecords;

  Result :=
    MapDocumentChargeSetHolderToChargesInfoDTO(DocumentChargesFormViewModel);
  
end;

function TDocumentChargesFormViewModelMapper.
  MapDocumentChargesFormViewModelToChangedChargesInfoDTO(
    DocumentChargesFormViewModel: TDocumentChargesFormViewModel
  ): TDocumentChargesInfoDTO;
begin

  DocumentChargesFormViewModel.
    DocumentChargeSetHolder.
      RevealChangedChargeRecords;

  Result :=
    MapDocumentChargeSetHolderToChargesInfoDTO(DocumentChargesFormViewModel);
    
end;

function TDocumentChargesFormViewModelMapper.
  MapDocumentChargesFormViewModelToRemovedChargesInfoDTO(
    DocumentChargesFormViewModel: TDocumentChargesFormViewModel
  ): TDocumentChargesInfoDTO;
begin

  DocumentChargesFormViewModel.
    DocumentChargeSetHolder.
      RevealRemovedChargeRecords;

  Result :=
    MapDocumentChargeSetHolderToChargesInfoDTO(DocumentChargesFormViewModel);
    
end;

function TDocumentChargesFormViewModelMapper.
  MapDocumentChargeSetHolderToChargesInfoDTO(
    DocumentChargesFormViewModel: TDocumentChargesFormViewModel
  ): TDocumentChargesInfoDTO;
var DocumentChargeInfoDTO: TDocumentChargeInfoDTO;
begin

  Result := TDocumentChargesInfoDTO.Create;

  try

    with
      DocumentChargesFormViewModel,
      DocumentChargesFormViewModel.DocumentChargeSetHolder
    do begin

      DocumentChargeSetHolder.First;

      while not Eof do begin

        { conditional refactor: см. TDocumentChargesFormViewModel }
        DocumentChargeInfoDTO := DocumentChargeKindDto.ChargeInfoDTOClass.Create;

        Result.Add(DocumentChargeInfoDTO);

        DocumentChargeInfoDTO.Id := IdFieldValue;

        DocumentChargeInfoDTO.KindId := ChargeKindIdFieldValue;
        
        DocumentChargeInfoDTO.PerformerInfoDTO := TDocumentFlowEmployeeInfoDTO.Create;

        DocumentChargeInfoDTO.PerformerInfoDTO.FullName := ReceiverFullNameFieldValue;

        DocumentChargeInfoDTO.PerformerInfoDTO.Speciality := ReceiverSpecialityFieldValue;

        DocumentChargeInfoDTO.PerformerInfoDTO.Id := ReceiverIdFieldValue;

        DocumentChargeInfoDTO.IsForAcquaitance := IsChargeForAcquaitanceFieldValue;

        DocumentChargeInfoDTO.PerformerInfoDTO.DepartmentInfoDTO := TDepartmentInfoDTO.Create;

        DocumentChargeInfoDTO.PerformerInfoDTO.DepartmentInfoDTO.Name :=
          ReceiverDepartmentNameFieldValue;

        DocumentChargeInfoDTO.PerformerResponse :=
          DocumentChargeSetHolder.ReceiverCommentFieldValue;
        
        DocumentChargeInfoDTO.PerformingDateTime := ReceiverPerformingDateTimeFieldValue;

        DocumentChargeInfoDTO.PerformerInfoDTO.IsForeign := IsReceiverForeignFieldValue;

        DocumentChargeInfoDTO.ChargeText := ChargeTextFieldValue;
        
        DocumentChargeInfoDTO.PerformerInfoDTO.LeaderId := ReceiverLeaderIdFieldValue;

        Next;
      
      end;

    end;

  except

    on e: Exception do begin

      FreeAndNil(Result);

      Raise;

    end;

  end;

end;

end.
