unit DocumentFullInfoDTO;

interface

uses

  DocumentResponsibleInfoDTO,
  DocumentFlowEmployeeInfoDTO,
  DocumentChargeSheetsInfoDTO,
  DepartmentInfoDTO,
  DocumentApprovings,
  Disposable,
  SysUtils,
  VariantListUnit,
  Classes;

type

  TDocumentRelationInfoDTO = class

    public

      TargetDocumentId: Variant;
      RelatedDocumentId: Variant;
      RelatedDocumentKindId: Variant;
      RelatedDocumentKindName: String;
      RelatedDocumentNumber: String;
      RelatedDocumentName: String;
      RelatedDocumentDate: TDateTime;

      constructor Create;

  end;

  TDocumentRelationsInfoDTO = class;

  TDocumentRelationsInfoDTOEnumerator = class (TListEnumerator)

    private

      function GetCurrentDocumentRelationInfoDTO: TDocumentRelationInfoDTO;

    public

      constructor Create(DocumentRelationsInfoDTO: TDocumentRelationsInfoDTO);

      property Current: TDocumentRelationInfoDTO
      read GetCurrentDocumentRelationInfoDTO;

  end;

  TDocumentRelationsInfoDTO = class (TList)

    private

      function GetDocumentRelationInfoDTOByIndex(
        Index: Integer
      ): TDocumentRelationInfoDTO;

      procedure SetDocumentRelationInfoDTOByIndex(
        Index: Integer;
        DocumentRelationInfoDTO: TDocumentRelationInfoDTO
      );

    public

      function GetEnumerator: TDocumentRelationsInfoDTOEnumerator;

      function Add(DocumentRelationInfoDTO: TDocumentRelationInfoDTO): Integer;

      procedure Notify(Ptr: Pointer; Action: TListNotification); override;

      property Items[Index: Integer]: TDocumentRelationInfoDTO
      read GetDocumentRelationInfoDTOByIndex
      write SetDocumentRelationInfoDTOByIndex; default;

  end;

  TDocumentFileInfoDTO = class

    public

      Id: Variant;
      DocumentId: Variant;
      FileName: String;
      FilePath: String;

      constructor Create;

  end;

  TDocumentFilesInfoDTO = class;

  TDocumentFilesInfoDTOEnumerator = class (TListEnumerator)

    strict private

      function GetCurrentDocumentFileInfoDTO: TDocumentFileInfoDTO;

    public

      constructor Create(DocumentFilesInfoDTO: TDocumentFilesInfoDTO);

      property Current: TDocumentFileInfoDTO
      read GetCurrentDocumentFileInfoDTO;

  end;

  TDocumentFilesInfoDTO = class (TList)

    strict private

      function GetDocumentFileInfoDTOByIndex(
        Index: Integer
      ): TDocumentFileInfoDTO;

      procedure SetDocumentFileInfoDTOByIndex(
        Index: Integer;
        DocumentFileInfoDTO: TDocumentFileInfoDTO
      );

    strict protected

      procedure Notify(Ptr: Pointer; Action: TListNotification); override;

    public

      function GetEnumerator: TDocumentFilesInfoDTOEnumerator;

      function Add(DocumentFileInfoDTO: TDocumentFileInfoDTO): Integer;
      procedure Remove(const Index: Integer);

      property Items[Index: Integer]: TDocumentFileInfoDTO
      read GetDocumentFileInfoDTOByIndex
      write SetDocumentFileInfoDTOByIndex; default;

  end;

  TDocumentApprovingPerformingResult = (prApproved, prNotApproved, prNotPerformed);

  {
    refactor: заменить IsAccessible на AccessRights
    с перечным прав доступа, подобно тому, как это реализовано в
    TDocumentChargeSheetInfoDTO
  }
  TDocumentApprovingInfoDTO = class

    public

      Id: Variant;
      TopLevelApprovingId: Variant;
      PerformingDateTime: Variant;
      PerformingResult: TDocumentApprovingPerformingResult;
      PerformingResultName: String;
      IsAccessible: Boolean;
      Note: String;

      IsViewedByApprover: Boolean;
      
      ApproverInfoDTO: TDocumentFlowEmployeeInfoDTO;
      ActuallyPerformedEmployeeInfoDTO: TDocumentFlowEmployeeInfoDTO;

      destructor Destroy; override;
      constructor Create;

      procedure SetPerformingResultFromDomain(
        const DomainApprovingPerformingResult: DocumentApprovings.TDocumentApprovingPerformingResult
      );
          
  end;

  TDocumentApprovingsInfoDTO = class;

  TDocumentApprovingsInfoDTOEnumerator = class (TListEnumerator)

    protected

      function GetCurrentDocumentApprovingInfoDTO: TDocumentApprovingInfoDTO;

    public

      constructor Create(DocumentApprovingsInfoDTO: TDocumentApprovingsInfoDTO);

      property Current: TDocumentApprovingInfoDTO
      read GetCurrentDocumentApprovingInfoDTO;
      
  end;

  TDocumentApprovingsInfoDTO = class (TList)

    protected

      function GetDocumentApprovingInfoDTOByIndex(
        Index: Integer
      ): TDocumentApprovingInfoDTO;

      procedure SetDocumentApprovingInfoDTOByIndex(
        Index: Integer;
        Value: TDocumentApprovingInfoDTO
      );

      procedure Notify(Ptr: Pointer; Action: TListNotification); override;
      
    public

      function Add(DocumentApprovingInfoDTO: TDocumentApprovingInfoDTO): Integer;

      function FindByApprovingId(const ApprovingId: Variant): TDocumentApprovingInfoDTO;
    
      function GetEnumerator: TDocumentApprovingsInfoDTOEnumerator;

      property Items[Index: Integer]: TDocumentApprovingInfoDTO
      read GetDocumentApprovingInfoDTOByIndex
      write SetDocumentApprovingInfoDTOByIndex; default;
      
  end;

  TDocumentApprovingCycleResultInfoDTO = class

    public

      Id: Variant;
      CycleNumber: Integer;

      DocumentApprovingsInfoDTO: TDocumentApprovingsInfoDTO;

      destructor Destroy; override;
      
  end;

  TDocumentApprovingCycleResultsInfoDTO = class;

  TDocumentApprovingCycleResultsInfoDTOEnumerator = class (TListEnumerator)

    protected

      function GetCurrentDocumentApprovingCycleResultInfoDTO:
        TDocumentApprovingCycleResultInfoDTO;

    public

      constructor Create(
        DocumentApprovingCycleResultsInfoDTO: TDocumentApprovingCycleResultsInfoDTO
      );

      property Current: TDocumentApprovingCycleResultInfoDTO
      read GetCurrentDocumentApprovingCycleResultInfoDTO;

  end;

  TDocumentApprovingCycleResultsInfoDTO = class (TList)

    protected

      function GetDocumentApprovingCycleResultInfoDTOByIndex(
        Index: Integer
      ): TDocumentApprovingCycleResultInfoDTO;

      procedure SetDocumentApprovingCycleResultInfoDTOByIndex(
        Index: Integer;
        Value: TDocumentApprovingCycleResultInfoDTO
      );

      procedure Notify(Ptr: Pointer; Action: TListNotification); override;
      
    public

      function Add(
        DocumentApprovingCycleResultInfoDTO: TDocumentApprovingCycleResultInfoDTO
      ): Integer;

      function FindByCycleNumber(
        const CycleNumber: Integer
      ): TDocumentApprovingCycleResultInfoDTO;
      
      function GetEnumerator: TDocumentApprovingCycleResultsInfoDTOEnumerator;

      property Items[Index: Integer]: TDocumentApprovingCycleResultInfoDTO
      read GetDocumentApprovingCycleResultInfoDTOByIndex
      write SetDocumentApprovingCycleResultInfoDTOByIndex; default;

  end;
  
  TDocumentSigningInfoDTO = class

    public

      Id: Variant;
      SignerInfoDTO: TDocumentFlowEmployeeInfoDTO;
      ActuallySignedEmployeeInfoDTO: TDocumentFlowEmployeeInfoDTO;
      SigningDate: Variant;

      constructor Create;
      destructor Destroy; override;
      
  end;

  TDocumentSigningsInfoDTO = class;

  TDocumentSigningsInfoDTOEnumerator = class (TListEnumerator)

    private

      function GetCurrentDocumentSigningInfoDTO:
        TDocumentSigningInfoDTO;

    public

      constructor Create(DocumentSigningsInfoDTO: TDocumentSigningsInfoDTO);

      property Current: TDocumentSigningInfoDTO
      read GetCurrentDocumentSigningInfoDTO;
      
  end;
  
  TDocumentSigningsInfoDTO = class (TList)

    private

      function GetDocumentSigningInfoDTOByIndex(
        Index: Integer
      ): TDocumentSigningInfoDTO;

      procedure SetDocumentSigningInfoDTOByIndex(
        Index: Integer;
        DocumentSigningInfoDTO: TDocumentSigningInfoDTO
      );

    protected

      procedure Notify(Ptr: Pointer; Action: TListNotification); override;

    public

      function FindSigningInfoDTOById(const SigningId: Variant): TDocumentSigningInfoDTO;
      function FindSigningInfoDTOBySignerId(const SignerId: Variant): TDocumentSigningInfoDTO;
    
      function Add(DocumentSigningInfoDTO: TDocumentSigningInfoDTO): Integer;

      function GetEnumerator: TDocumentSigningsInfoDTOEnumerator;

      property Items[Index: Integer]: TDocumentSigningInfoDTO
      read GetDocumentSigningInfoDTOByIndex
      write SetDocumentSigningInfoDTOByIndex; default;
    
  end;

  TDocumentChargeAccessRightsDTO = class

    public

      ChargeSectionAccessible: Variant;
      RemovingAllowed: Variant;

      constructor Create;
      
  end;

  TDocumentChargeInfoDTO = class

    private

      FAccessRights: TDocumentChargeAccessRightsDTO;
      
      procedure SetAccessRights(const Value: TDocumentChargeAccessRightsDTO);

    protected

      function CreateAccessRightsDTOInstance: TDocumentChargeAccessRightsDTO; virtual;
      
    public

      Id: Variant;
      KindId: Variant;
      KindName: String;
      ServiceKindName: String;
      
      ChargeText: String;
      PerformerResponse: String;
      
      TimeFrameStart: Variant;
      TimeFrameDeadline: Variant;
      PerformingDateTime: Variant;

      IsForAcquaitance: Boolean;
      
      PerformerInfoDTO: TDocumentFlowEmployeeInfoDTO;
      ActuallyPerformedEmployeeInfoDTO: TDocumentFlowEmployeeInfoDTO;
      
      constructor Create;
      destructor Destroy; override;

      property AccessRights: TDocumentChargeAccessRightsDTO
      read FAccessRights write SetAccessRights;
      
      class function ChargeSheetInfoDTOClass: TClass; virtual;

  end;

  TDocumentChargeInfoDTOClass = class of TDocumentChargeInfoDTO;

  TDocumentAcquaitanceInfoDTO = class (TDocumentChargeInfoDTO)

    public

      class function ChargeSheetInfoDTOClass: TClass; override;
      
  end;

  TDocumentPerformingInfoDTO = class (TDocumentChargeInfoDTO)

    public

      class function ChargeSheetInfoDTOClass: TClass; override;
      
  end;

  TDocumentChargesInfoDTO = class;

  TDocumentChargesInfoDTOEnumerator = class (TListEnumerator)

    strict private

      function GetCurrentDocumentChargeInfoDTO: TDocumentChargeInfoDTO;

    public

      constructor Create(DocumentChargesInfoDTO: TDocumentChargesInfoDTO);

      property Current: TDocumentChargeInfoDTO
      read GetCurrentDocumentChargeInfoDTO;

  end;

  TDocumentChargesInfoDTO = class (TList)

    strict private

      function GetDocumentChargeInfoDTOByIndex(
        Index: Integer
      ): TDocumentChargeInfoDTO;

      procedure SetDocumentChargeInfoDTOByIndex(
        Index: Integer;
        DocumentChargeInfoDTO: TDocumentChargeInfoDTO
      );

    strict protected

      procedure Notify(Ptr: Pointer; Action: TListNotification); override;

    public

      function ExtractPerformerIds: TVariantList;

      function FindChargeByPerformerId(const PerformerId: Variant): TDocumentChargeInfoDTO;
      
      function Add(DocumentChargeInfoDTO: TDocumentChargeInfoDTO): Integer;
      procedure Remove(const Index: Integer);

      function GetEnumerator: TDocumentChargesInfoDTOEnumerator;

      property Items[Index: Integer]: TDocumentChargeInfoDTO
      read GetDocumentChargeInfoDTOByIndex
      write SetDocumentChargeInfoDTOByIndex; default;

  end;

  TDocumentDTO = class

    protected

      FId: Variant;
      FBaseDocumentId: Variant;
      FNumber: String;
      FSeparatorOfNumberParts: String;
      FName: String;
      FContent: String;
      FCreationDate: TDateTime;
      FDocumentDate: Variant;
      FNote: String;
      FProductCode: String;
      FIsSelfRegistered: Variant;
      FKind: String;
      FKindId: Variant;

      FAuthorDTO: TDocumentFlowEmployeeInfoDTO;

      FChargesInfoDTO: TDocumentChargesInfoDTO;
      FApprovingsInfoDTO: TDocumentApprovingsInfoDTO;
      FSigningsInfoDTO: TDocumentSigningsInfoDTO;
      FResponsibleInfoDTO: TDocumentResponsibleInfoDTO;

      FCurrentWorkCycleStageNumber: Integer;
      FCurrentWorkCycleStageName: String;

      function GetApprovingsInfoDTO: TDocumentApprovingsInfoDTO; virtual;
      function GetAuthorDTO: TDocumentFlowEmployeeInfoDTO; virtual;
      function GetChargesInfoDTO: TDocumentChargesInfoDTO; virtual;
      function GetContent: String; virtual;
      function GetCreationDate: TDateTime; virtual;
      function GetDocumentDate: Variant; virtual;
      function GetCurrentWorkCycleStageName: String; virtual;
      function GetCurrentWorkCycleStageNumber: Integer; virtual;
      function GetId: Variant; virtual;
      function GetBaseDocumentId: Variant; virtual;
      function GetKind: String; virtual;
      function GetKindId: Variant; virtual;
      function GetName: String; virtual;
      function GetNote: String; virtual;
      function GetProductCode: String; virtual;
      function GetNumber: String; virtual;
      function GetResponsibleInfoDTO: TDocumentResponsibleInfoDTO; virtual;
      function GetSeparatorOfNumberParts: String; virtual;
      function GetIsSelfRegistered: Variant; virtual;
      
      function GetSigningsInfoDTO: TDocumentSigningsInfoDTO; virtual;
      procedure SetApprovingsInfoDTO(const Value: TDocumentApprovingsInfoDTO); virtual;
      procedure SetAuthorDTO(const Value: TDocumentFlowEmployeeInfoDTO); virtual;
      procedure SetChargesInfoDTO(const Value: TDocumentChargesInfoDTO); virtual;
      procedure SetContent(const Value: String); virtual;
      procedure SetProductCode(const Value: String); virtual;
      procedure SetCreationDate(const Value: TDateTime); virtual;
      procedure SetDocumentDate(const Value: Variant); virtual;
      procedure SetCurrentWorkCycleStageName(const Value: String); virtual;
      procedure SetCurrentWorkCycleStageNumber(const Value: Integer); virtual;
      procedure SetId(const Value: Variant); virtual;
      procedure SetBaseDocumentId(const Value: Variant); virtual;
      procedure SetKind(const Value: String); virtual;
      procedure SetKindId(const Value: Variant); virtual;
      procedure SetName(const Value: String); virtual;
      procedure SetNote(const Value: String); virtual;
      procedure SetNumber(const Value: String); virtual;
      procedure SetResponsibleInfoDTO(const Value: TDocumentResponsibleInfoDTO); virtual;
      procedure SetSeparatorOfNumberParts(const Value: String); virtual;
      procedure SetSigningsInfoDTO(const Value: TDocumentSigningsInfoDTO); virtual;
      procedure SetIsSelfRegistered(const Value: Variant); virtual;
      
    public

      property Id: Variant
      read GetId write SetId;

      property BaseDocumentId: Variant
      read GetBaseDocumentId write SetBaseDocumentId;
      
      property Number: String
      read GetNumber write SetNumber;

      property SeparatorOfNumberParts: String
      read GetSeparatorOfNumberParts write SetSeparatorOfNumberParts;
      
      property Name: String
      read GetName write SetName;

      property ProductCode: String
      read GetProductCode write SetProductCode;
      
      property Content: String
      read GetContent write SetContent;
      
      property CreationDate: TDateTime
      read GetCreationDate write SetCreationDate;

      property DocumentDate: Variant
      read GetDocumentDate write SetDocumentDate;
      
      property Note: String
      read GetNote write SetNote;
      
      property Kind: String
      read GetKind write SetKind;

      property KindId: Variant
      read GetKindId write SetKindId;

      property AuthorDTO: TDocumentFlowEmployeeInfoDTO
      read GetAuthorDTO write SetAuthorDTO;

      property ChargesInfoDTO: TDocumentChargesInfoDTO
      read GetChargesInfoDTO write SetChargesInfoDTO;

      property ApprovingsInfoDTO: TDocumentApprovingsInfoDTO
      read GetApprovingsInfoDTO write SetApprovingsInfoDTO;

      property SigningsInfoDTO: TDocumentSigningsInfoDTO
      read GetSigningsInfoDTO write SetSigningsInfoDTO;

      property ResponsibleInfoDTO: TDocumentResponsibleInfoDTO
      read GetResponsibleInfoDTO write SetResponsibleInfoDTO;

      property CurrentWorkCycleStageNumber: Integer
      read GetCurrentWorkCycleStageNumber write SetCurrentWorkCycleStageNumber;

      property CurrentWorkCycleStageName: String
      read GetCurrentWorkCycleStageName write SetCurrentWorkCycleStageName;

      property IsSelfRegistered: Variant
      read GetIsSelfRegistered write SetIsSelfRegistered;
      
      constructor Create; virtual;
      destructor Destroy; override;

  end;

  TDocumentFullInfoDTO = class (TInterfacedObject, IDisposable)

    public

      DocumentDTO: TDocumentDTO;
      DocumentRelationsInfoDTO: TDocumentRelationsInfoDTO;
      DocumentFilesInfoDTO: TDocumentFilesInfoDTO;

      DocumentApprovingCycleResultsInfoDTO: TDocumentApprovingCycleResultsInfoDTO;
      DocumentChargeSheetsInfoDTO: TDocumentChargeSheetsInfoDTO;

      destructor Destroy; override;

  end;

implementation

uses

  Variants;
  
{ TDocumentRelationsInfoDTOEnumerator }

constructor TDocumentRelationsInfoDTOEnumerator.Create(
  DocumentRelationsInfoDTO: TDocumentRelationsInfoDTO);
begin

  inherited Create(DocumentRelationsInfoDTO);

end;

function TDocumentRelationsInfoDTOEnumerator.GetCurrentDocumentRelationInfoDTO: TDocumentRelationInfoDTO;
begin

  Result := TDocumentRelationInfoDTO(GetCurrent);
  
end;

{ TDocumentRelationsInfoDTO }

function TDocumentRelationsInfoDTO.Add(
  DocumentRelationInfoDTO: TDocumentRelationInfoDTO): Integer;
begin

  Result := inherited Add(DocumentRelationInfoDTO);
  
end;

function TDocumentRelationsInfoDTO.GetDocumentRelationInfoDTOByIndex(
  Index: Integer): TDocumentRelationInfoDTO;
begin

  Result := TDocumentRelationInfoDTO(Get(Index));
  
end;

function TDocumentRelationsInfoDTO.GetEnumerator: TDocumentRelationsInfoDTOEnumerator;
begin

  Result := TDocumentRelationsInfoDTOEnumerator.Create(Self);
  
end;

procedure TDocumentRelationsInfoDTO.Notify(Ptr: Pointer;
  Action: TListNotification);
begin

  if Action = lnDeleted then
    if Assigned(Ptr) then
      TDocumentRelationInfoDTO(Ptr).Destroy;

end;

procedure TDocumentRelationsInfoDTO.SetDocumentRelationInfoDTOByIndex(
  Index: Integer; DocumentRelationInfoDTO: TDocumentRelationInfoDTO);
begin

  Put(Index, DocumentRelationInfoDTO);
  
end;

{ TDocumentFilesInfoDTOEnumerator }

constructor TDocumentFilesInfoDTOEnumerator.Create(
  DocumentFilesInfoDTO: TDocumentFilesInfoDTO);
begin

  inherited Create(DocumentFilesInfoDTO);
  
end;

function TDocumentFilesInfoDTOEnumerator.GetCurrentDocumentFileInfoDTO: TDocumentFileInfoDTO;
begin

  Result := TDocumentFileInfoDTO(GetCurrent);
  
end;

{ TDocumentFilesInfoDTO }

function TDocumentFilesInfoDTO.Add(
  DocumentFileInfoDTO: TDocumentFileInfoDTO): Integer;
begin

  Result := inherited Add(DocumentFileInfoDTO);

end;

function TDocumentFilesInfoDTO.GetDocumentFileInfoDTOByIndex(
  Index: Integer): TDocumentFileInfoDTO;
begin

  Result := TDocumentFileInfoDTO(Get(Index));

end;

function TDocumentFilesInfoDTO.GetEnumerator: TDocumentFilesInfoDTOEnumerator;
begin

  Result := TDocumentFilesInfoDTOEnumerator.Create(Self);
  
end;

procedure TDocumentFilesInfoDTO.Notify(Ptr: Pointer; Action: TListNotification);
begin

  if Action = lnDeleted then
    if Assigned(Ptr) then
      TDocumentFileInfoDTO(Ptr).Destroy;

end;

procedure TDocumentFilesInfoDTO.Remove(const Index: Integer);
begin

  Delete(Index);
  
end;

procedure TDocumentFilesInfoDTO.SetDocumentFileInfoDTOByIndex(Index: Integer;
  DocumentFileInfoDTO: TDocumentFileInfoDTO);
begin

  Put(Index, DocumentFileInfoDTO);
  
end;

{ TDocumentChargesInfoDTOEnumerator }

constructor TDocumentChargesInfoDTOEnumerator.Create(
  DocumentChargesInfoDTO: TDocumentChargesInfoDTO);
begin

  inherited Create(DocumentChargesInfoDTO);
  
end;

function TDocumentChargesInfoDTOEnumerator.GetCurrentDocumentChargeInfoDTO: TDocumentChargeInfoDTO;
begin

  Result := TDocumentChargeInfoDTO(GetCurrent);
  
end;

{ TDocumentChargesInfoDTO }

function TDocumentChargesInfoDTO.Add(
  DocumentChargeInfoDTO: TDocumentChargeInfoDTO): Integer;
begin

  Result := inherited Add(DocumentChargeInfoDTO);
  
end;

function TDocumentChargesInfoDTO.ExtractPerformerIds: TVariantList;
var
    ChargeInfoDTO: TDocumentChargeInfoDTO;
begin

  Result := TVariantList.Create;

  try

    for ChargeInfoDTO in Self do begin

      if not Result.Contains(ChargeInfoDTO.PerformerInfoDTO.Id) then
        Result.Add(ChargeInfoDTO.PerformerInfoDTO.Id);
        
    end;

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

function TDocumentChargesInfoDTO.FindChargeByPerformerId(
  const PerformerId: Variant): TDocumentChargeInfoDTO;
begin

  for Result in Self do
    if Result.PerformerInfoDTO.Id = PerformerId then
      Exit;

  Result := nil;
  
end;

function TDocumentChargesInfoDTO.GetDocumentChargeInfoDTOByIndex(
  Index: Integer): TDocumentChargeInfoDTO;
begin

  Result := TDocumentChargeInfoDTO(Get(Index));
  
end;

function TDocumentChargesInfoDTO.GetEnumerator: TDocumentChargesInfoDTOEnumerator;
begin

  Result := TDocumentChargesInfoDTOEnumerator.Create(Self);
  
end;

procedure TDocumentChargesInfoDTO.Notify(Ptr: Pointer;
  Action: TListNotification);
begin

  if lnDeleted = Action then
    if Assigned(Ptr) then
      TDocumentChargeInfoDTO(Ptr).Destroy;

end;

procedure TDocumentChargesInfoDTO.Remove(const Index: Integer);
begin

  Delete(Index);
  
end;

procedure TDocumentChargesInfoDTO.SetDocumentChargeInfoDTOByIndex(
  Index: Integer; DocumentChargeInfoDTO: TDocumentChargeInfoDTO);
begin

  Put(Index, DocumentChargeInfoDTO);

end;

{ TDocumentDTO }

constructor TDocumentDTO.Create;
begin

  inherited;

  FId := Null;
  FBaseDocumentId := Null;
  FIsSelfRegistered := Null;
  FDocumentDate := Null;
  
end;

destructor TDocumentDTO.Destroy;
begin

  FreeAndNil(FAuthorDTO);
  FreeAndNil(FResponsibleInfoDTO);
  FreeAndNil(FChargesInfoDTO);
  FreeAndNil(FApprovingsInfoDTO);
  FreeAndNil(FSigningsInfoDTO);
  
  inherited;

end;

function TDocumentDTO.GetApprovingsInfoDTO: TDocumentApprovingsInfoDTO;
begin

  Result := FApprovingsInfoDTO;
  
end;

function TDocumentDTO.GetAuthorDTO: TDocumentFlowEmployeeInfoDTO;
begin

  Result := FAuthorDTO;
  
end;

function TDocumentDTO.GetBaseDocumentId: Variant;
begin

  Result := FBaseDocumentId;
  
end;

function TDocumentDTO.GetChargesInfoDTO: TDocumentChargesInfoDTO;
begin

  Result := FChargesInfoDTO;
  
end;

function TDocumentDTO.GetContent: String;
begin

  Result := FContent;
  
end;

function TDocumentDTO.GetCreationDate: TDateTime;
begin

  Result := FCreationDate;
  
end;

function TDocumentDTO.GetCurrentWorkCycleStageName: String;
begin

  Result := FCurrentWorkCycleStageName;
  
end;

function TDocumentDTO.GetCurrentWorkCycleStageNumber: Integer;
begin

  Result := FCurrentWorkCycleStageNumber;
  
end;

function TDocumentDTO.GetDocumentDate: Variant;
begin

  Result := FDocumentDate;
  
end;

function TDocumentDTO.GetId: Variant;
begin

  Result := FId;

end;

function TDocumentDTO.GetIsSelfRegistered: Variant;
begin

  Result := FIsSelfRegistered;
  
end;

function TDocumentDTO.GetKind: String;
begin

  Result := FKind;

end;

function TDocumentDTO.GetKindId: Variant;
begin

  Result := FKindId;
  
end;

function TDocumentDTO.GetName: String;
begin

  Result := FName;
  
end;

function TDocumentDTO.GetNote: String;
begin

  Result := FNote;
  
end;

function TDocumentDTO.GetNumber: String;
begin

  Result := FNumber;
  
end;

function TDocumentDTO.GetProductCode: String;
begin

  Result := FProductCode;

end;

function TDocumentDTO.GetResponsibleInfoDTO: TDocumentResponsibleInfoDTO;
begin

  Result := FResponsibleInfoDTO;
  
end;

function TDocumentDTO.GetSeparatorOfNumberParts: String;
begin

  Result := FSeparatorOfNumberParts;

end;

function TDocumentDTO.GetSigningsInfoDTO: TDocumentSigningsInfoDTO;
begin

  Result := FSigningsInfoDTO;
  
end;

procedure TDocumentDTO.SetApprovingsInfoDTO(
  const Value: TDocumentApprovingsInfoDTO);
begin

  FApprovingsInfoDTO := Value;

end;

procedure TDocumentDTO.SetAuthorDTO(const Value: TDocumentFlowEmployeeInfoDTO);
begin

  FAuthorDTO := Value;
  
end;

procedure TDocumentDTO.SetBaseDocumentId(const Value: Variant);
begin

  FBaseDocumentId := Value;
  
end;

procedure TDocumentDTO.SetChargesInfoDTO(const Value: TDocumentChargesInfoDTO);
begin

  FChargesInfoDTO := Value;

end;

procedure TDocumentDTO.SetContent(const Value: String);
begin

  FContent := Value;
  
end;

procedure TDocumentDTO.SetCreationDate(const Value: TDateTime);
begin

  FCreationDate := Value;

end;

procedure TDocumentDTO.SetCurrentWorkCycleStageName(const Value: String);
begin

  FCurrentWorkCycleStageName := Value;

end;

procedure TDocumentDTO.SetCurrentWorkCycleStageNumber(const Value: Integer);
begin

  FCurrentWorkCycleStageNumber := Value;
  
end;

procedure TDocumentDTO.SetDocumentDate(const Value: Variant);
begin

  FDocumentDate := Value;
  
end;

procedure TDocumentDTO.SetId(const Value: Variant);
begin

  FId := Value;

end;

procedure TDocumentDTO.SetIsSelfRegistered(const Value: Variant);
begin

  FIsSelfRegistered := Value;

end;

procedure TDocumentDTO.SetKind(const Value: String);
begin

  FKind := Value;
  
end;

procedure TDocumentDTO.SetKindId(const Value: Variant);
begin

  FKindId := Value;
  
end;

procedure TDocumentDTO.SetName(const Value: String);
begin

  FName := Value;
  
end;

procedure TDocumentDTO.SetNote(const Value: String);
begin

  FNote := Value;
  
end;

procedure TDocumentDTO.SetNumber(const Value: String);
begin

  FNumber := Value;

end;

procedure TDocumentDTO.SetProductCode(const Value: String);
begin

  FProductCode := Value;

end;

procedure TDocumentDTO.SetResponsibleInfoDTO(
  const Value: TDocumentResponsibleInfoDTO);
begin

  FResponsibleInfoDTO := Value;
  
end;

procedure TDocumentDTO.SetSeparatorOfNumberParts(const Value: String);
begin

  FSeparatorOfNumberParts := Value;

end;

procedure TDocumentDTO.SetSigningsInfoDTO(
  const Value: TDocumentSigningsInfoDTO);
begin

  FSigningsInfoDTO := Value;
  
end;

{ TDocumentFullInfoDTO }

destructor TDocumentFullInfoDTO.Destroy;
begin

  FreeAndNil(DocumentDTO);
  FreeAndNil(DocumentApprovingCycleResultsInfoDTO);
  FreeAndNil(DocumentChargeSheetsInfoDTO);
  FreeAndNil(DocumentRelationsInfoDTO);
  FreeAndNil(DocumentFilesInfoDTO);
  
  inherited;

end;

{ TDocumentSigningsInfoDTOEnumerator }

constructor TDocumentSigningsInfoDTOEnumerator.Create(
  DocumentSigningsInfoDTO: TDocumentSigningsInfoDTO);
begin

  inherited Create(DocumentSigningsInfoDTO);
  
end;

function TDocumentSigningsInfoDTOEnumerator.GetCurrentDocumentSigningInfoDTO: TDocumentSigningInfoDTO;
begin

  Result := TDocumentSigningInfoDTO(GetCurrent);
  
end;

{ TDocumentSigningsInfoDTO }

function TDocumentSigningsInfoDTO.Add(
  DocumentSigningInfoDTO: TDocumentSigningInfoDTO
): Integer;
begin

  Result := inherited Add(DocumentSigningInfoDTO);

end;

function TDocumentSigningsInfoDTO.FindSigningInfoDTOById(
  const SigningId: Variant): TDocumentSigningInfoDTO;
begin

  for Result in Self do
    if Result.Id = SigningId then
      Exit;

  Result := nil;
  
end;

function TDocumentSigningsInfoDTO.FindSigningInfoDTOBySignerId(
  const SignerId: Variant): TDocumentSigningInfoDTO;
begin

  for Result in Self do
    if Result.SignerInfoDTO.Id = SignerId then
      Exit;

  Result := nil;
    
end;

function TDocumentSigningsInfoDTO.GetDocumentSigningInfoDTOByIndex(
  Index: Integer): TDocumentSigningInfoDTO;
begin

  Result := TDocumentSigningInfoDTO(Get(Index));
  
end;

function TDocumentSigningsInfoDTO.GetEnumerator: TDocumentSigningsInfoDTOEnumerator;
begin

  Result := TDocumentSigningsInfoDTOEnumerator.Create(Self);
  
end;

procedure TDocumentSigningsInfoDTO.Notify(Ptr: Pointer;
  Action: TListNotification);
begin

  if Action = lnDeleted then
    if Assigned(Ptr) then
      TDocumentSigningInfoDTO(Ptr).Destroy;

end;

procedure TDocumentSigningsInfoDTO.SetDocumentSigningInfoDTOByIndex(
  Index: Integer; DocumentSigningInfoDTO: TDocumentSigningInfoDTO);
begin

  Put(Index, DocumentSigningInfoDTO);

end;

{ TDocumentSigningInfoDTO }

constructor TDocumentSigningInfoDTO.Create;
begin

  inherited;

  Id := Null;
  SigningDate := Null;
  
end;

destructor TDocumentSigningInfoDTO.Destroy;
begin

  FreeAndNil(SignerInfoDTO);
  FreeAndNil(ActuallySignedEmployeeInfoDTO);
  inherited;

end;

{ TDocumentChargeInfoDTO }

class function TDocumentChargeInfoDTO.ChargeSheetInfoDTOClass: TClass;
begin

  Result := TDocumentChargeSheetInfoDTO;
  
end;

constructor TDocumentChargeInfoDTO.Create;
begin

  inherited;

  KindId := Null;
  TimeFrameStart := Null;
  TimeFrameDeadline := Null;
  PerformingDateTime := Null;

  FAccessRights := CreateAccessRightsDTOInstance;

end;

function TDocumentChargeInfoDTO.CreateAccessRightsDTOInstance: TDocumentChargeAccessRightsDTO;
begin

  Result := TDocumentChargeAccessRightsDTO.Create;
  
end;

destructor TDocumentChargeInfoDTO.Destroy;
begin

  FreeAndNil(PerformerInfoDTO);
  FreeAndNil(ActuallyPerformedEmployeeInfoDTO);
  
  inherited;

end;

procedure TDocumentChargeInfoDTO.SetAccessRights(
  const Value: TDocumentChargeAccessRightsDTO);
begin

  if FAccessRights = Value then Exit;

  FreeAndNil(FAccessRights);
  
  FAccessRights := Value;

end;

{ TDocumentFileInfoDTO }

constructor TDocumentFileInfoDTO.Create;
begin

  inherited;

  Id := Null;
  DocumentId := Null;
  
end;

{ TDocumentRelationInfoDTO }

constructor TDocumentRelationInfoDTO.Create;
begin

  inherited;

  TargetDocumentId := Null;
  RelatedDocumentId := Null;
  RelatedDocumentKindId := Null;
  
end;

{ TDocumentApprovingInfoDTO }

constructor TDocumentApprovingInfoDTO.Create;
begin

  inherited;

  Id := Null;
  TopLevelApprovingId := Null;
  PerformingDateTime := Null;

end;

destructor TDocumentApprovingInfoDTO.Destroy;
begin

  FreeAndNil(ApproverInfoDTO);
  FreeAndNil(ActuallyPerformedEmployeeInfoDTO);
  
  inherited;

end;

procedure TDocumentApprovingInfoDTO.SetPerformingResultFromDomain(
  const DomainApprovingPerformingResult: DocumentApprovings.TDocumentApprovingPerformingResult);
begin

  case DomainApprovingPerformingResult of

    DocumentApprovings.prApproved: PerformingResult := DocumentFullInfoDTO.prApproved;
    DocumentApprovings.prRejected: PerformingResult := DocumentFullInfoDTO.prNotApproved;
    DocumentApprovings.prNotPerformed: PerformingResult := DocumentFullInfoDTO.prNotPerformed;

    else begin

      raise Exception.Create(
        'Программная ошибка. Обнаружен ' +
        'неизвестный результат согласования ' +
        'во время его преобразования в DTO'
      );
          
    end;

  end;

end;

{ TDocumentApprovingsInfoDTO }

function TDocumentApprovingsInfoDTO.Add(
  DocumentApprovingInfoDTO: TDocumentApprovingInfoDTO): Integer;
begin

  Result := inherited Add(DocumentApprovingInfoDTO);
  
end;

function TDocumentApprovingsInfoDTO.FindByApprovingId(
  const ApprovingId: Variant): TDocumentApprovingInfoDTO;
begin

  for Result in Self do
    if not VarIsNull(Result.Id) and not VarIsNull(ApprovingId)
       and (Result.Id = ApprovingId)
    then Exit;

  Result := nil;
    
end;

function TDocumentApprovingsInfoDTO.GetDocumentApprovingInfoDTOByIndex(
  Index: Integer): TDocumentApprovingInfoDTO;
begin

  Result := TDocumentApprovingInfoDTO(Get(Index));
  
end;

function TDocumentApprovingsInfoDTO.GetEnumerator: TDocumentApprovingsInfoDTOEnumerator;
begin

  Result := TDocumentApprovingsInfoDTOEnumerator.Create(Self);
  
end;

procedure TDocumentApprovingsInfoDTO.Notify(Ptr: Pointer;
  Action: TListNotification);
begin

  if Action = lnDeleted then
    if Assigned(Ptr) then
      TDocumentApprovingInfoDTO(Ptr).Destroy;

end;

procedure TDocumentApprovingsInfoDTO.SetDocumentApprovingInfoDTOByIndex(
  Index: Integer; Value: TDocumentApprovingInfoDTO);
begin

  Put(Index, Value);
  
end;

{ TDocumentApprovingsInfoDTOEnumerator }

constructor TDocumentApprovingsInfoDTOEnumerator.Create(
  DocumentApprovingsInfoDTO: TDocumentApprovingsInfoDTO);
begin

  inherited Create(DocumentApprovingsInfoDTO);
  
end;

function TDocumentApprovingsInfoDTOEnumerator.GetCurrentDocumentApprovingInfoDTO: TDocumentApprovingInfoDTO;
begin

  Result := TDocumentApprovingInfoDTO(GetCurrent);
  
end;

{ TDocumentApprovingCycleResultInfoDTO }

destructor TDocumentApprovingCycleResultInfoDTO.Destroy;
begin

  FreeAndNil(DocumentApprovingsInfoDTO);
  
  inherited;

end;

{ TDocumentApprovingCycleResultsInfoDTOEnumerator }

constructor TDocumentApprovingCycleResultsInfoDTOEnumerator.Create(
  DocumentApprovingCycleResultsInfoDTO: TDocumentApprovingCycleResultsInfoDTO);
begin

  inherited Create(DocumentApprovingCycleResultsInfoDTO);
  
end;

function TDocumentApprovingCycleResultsInfoDTOEnumerator.GetCurrentDocumentApprovingCycleResultInfoDTO: TDocumentApprovingCycleResultInfoDTO;
begin

  Result := TDocumentApprovingCycleResultInfoDTO(GetCurrent);
  
end;

{ TDocumentApprovingCycleResultsInfoDTO }

function TDocumentApprovingCycleResultsInfoDTO.Add(
  DocumentApprovingCycleResultInfoDTO: TDocumentApprovingCycleResultInfoDTO): Integer;
begin

  Result := inherited Add(DocumentApprovingCycleResultInfoDTO);
  
end;

function TDocumentApprovingCycleResultsInfoDTO.FindByCycleNumber(
  const CycleNumber: Integer
): TDocumentApprovingCycleResultInfoDTO;
begin

  for Result in Self do
    if Result.CycleNumber = CycleNumber then
      Exit;

  Result := nil;

end;

function TDocumentApprovingCycleResultsInfoDTO.GetDocumentApprovingCycleResultInfoDTOByIndex(
  Index: Integer): TDocumentApprovingCycleResultInfoDTO;
begin

  Result := TDocumentApprovingCycleResultInfoDTO(Get(Index));
  
end;

function TDocumentApprovingCycleResultsInfoDTO.GetEnumerator: TDocumentApprovingCycleResultsInfoDTOEnumerator;
begin

  Result := TDocumentApprovingCycleResultsInfoDTOEnumerator.Create(Self);
  
end;

procedure TDocumentApprovingCycleResultsInfoDTO.Notify(Ptr: Pointer;
  Action: TListNotification);
begin

  if Action = lnDeleted then
    if Assigned(Ptr) then
      TDocumentApprovingCycleResultInfoDTO(Ptr).Destroy;

end;

procedure TDocumentApprovingCycleResultsInfoDTO.SetDocumentApprovingCycleResultInfoDTOByIndex(
  Index: Integer; Value: TDocumentApprovingCycleResultInfoDTO);
begin

  Put(Index, Value);
  
end;

{ TDocumentAcquaitanceInfoDTO }

class function TDocumentAcquaitanceInfoDTO.ChargeSheetInfoDTOClass: TClass;
begin

  Result := TDocumentAcquaitanceSheetInfoDTO;
  
end;

{ TDocumentPerformingInfoDTO }

class function TDocumentPerformingInfoDTO.ChargeSheetInfoDTOClass: TClass;
begin

  Result := TDocumentPerformingSheetInfoDTO;
  
end;

constructor TDocumentChargeAccessRightsDTO.Create;
begin

  inherited;

  ChargeSectionAccessible := Null;
  RemovingAllowed := Null;

end;
end.
