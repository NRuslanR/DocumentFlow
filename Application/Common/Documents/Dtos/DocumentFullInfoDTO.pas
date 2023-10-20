unit DocumentFullInfoDTO;

interface

uses

  DocumentResponsibleInfoDTO,
  DocumentFlowEmployeeInfoDTO,
  DocumentChargeSheetsInfoDTO,
  DepartmentInfoDTO,
  DocumentApprovings,
  IGetSelfUnit,
  Disposable,
  SysUtils,
  VariantListUnit,
  Classes;

type

  TDocumentRelationInfoDTO = class (TInterfacedObject, IGetSelf)

    public

      TargetDocumentId: Variant;
      RelatedDocumentId: Variant;
      RelatedDocumentKindId: Variant;
      RelatedDocumentKindName: String;
      RelatedDocumentNumber: String;
      RelatedDocumentName: String;
      RelatedDocumentDate: TDateTime;

      constructor Create;

      function GetSelf: TObject;

  end;

  TDocumentRelationsInfoDTO = class;

  TDocumentRelationsInfoDTOEnumerator = class (TInterfaceListEnumerator)

    private

      function GetCurrentDocumentRelationInfoDTO: TDocumentRelationInfoDTO;

    public

      constructor Create(DocumentRelationsInfoDTO: TDocumentRelationsInfoDTO);

      property Current: TDocumentRelationInfoDTO
      read GetCurrentDocumentRelationInfoDTO;

  end;

  TDocumentRelationsInfoDTO = class (TInterfaceList, IGetSelf)

    private

      function GetDocumentRelationInfoDTOByIndex(
        Index: Integer
      ): TDocumentRelationInfoDTO;

      procedure SetDocumentRelationInfoDTOByIndex(
        Index: Integer;
        DocumentRelationInfoDTO: TDocumentRelationInfoDTO
      );

    public

      function GetSelf: TObject;
      
      function GetEnumerator: TDocumentRelationsInfoDTOEnumerator;

      function Add(DocumentRelationInfoDTO: TDocumentRelationInfoDTO): Integer;

      property Items[Index: Integer]: TDocumentRelationInfoDTO
      read GetDocumentRelationInfoDTOByIndex
      write SetDocumentRelationInfoDTOByIndex; default;

  end;

  TDocumentFileInfoDTO = class (TInterfacedObject, IGetSelf)

    public

      Id: Variant;
      DocumentId: Variant;
      FileName: String;
      FilePath: String;

      constructor Create;

      function GetSelf: TObject;

  end;

  TDocumentFilesInfoDTO = class;

  TDocumentFilesInfoDTOEnumerator = class (TInterfaceListEnumerator)

    strict private

      function GetCurrentDocumentFileInfoDTO: TDocumentFileInfoDTO;

    public

      constructor Create(DocumentFilesInfoDTO: TDocumentFilesInfoDTO);

      property Current: TDocumentFileInfoDTO
      read GetCurrentDocumentFileInfoDTO;

  end;

  TDocumentFilesInfoDTO = class (TInterfaceList, IGetSelf)

    strict private

      function GetDocumentFileInfoDTOByIndex(
        Index: Integer
      ): TDocumentFileInfoDTO;

      procedure SetDocumentFileInfoDTOByIndex(
        Index: Integer;
        DocumentFileInfoDTO: TDocumentFileInfoDTO
      );

    public

      function GetSelf: TObject;
      
      function GetEnumerator: TDocumentFilesInfoDTOEnumerator;

      function Add(DocumentFileInfoDTO: TDocumentFileInfoDTO): Integer;
      procedure Remove(const Index: Integer);

      property Items[Index: Integer]: TDocumentFileInfoDTO
      read GetDocumentFileInfoDTOByIndex
      write SetDocumentFileInfoDTOByIndex; default;

  end;

  {
    refactor: заменить IsAccessible на AccessRights
    с перечным прав доступа, подобно тому, как это реализовано в
    TDocumentChargeSheetInfoDTO
  }
  TDocumentApprovingInfoDTO = class (TInterfacedObject, IGetSelf)

    private

      FApproverInfoDTO: TDocumentFlowEmployeeInfoDTO;
      FFreeApproverInfoDTO: IGetSelf;
      
      FActuallyPerformedEmployeeInfoDTO: TDocumentFlowEmployeeInfoDTO;
      FFreeActuallyPerformedEmployeeInfoDTO: IGetSelf;

      procedure SetActuallyPerformedEmployeeInfoDTO(
        const Value: TDocumentFlowEmployeeInfoDTO);

      procedure SetApproverInfoDTO(const Value: TDocumentFlowEmployeeInfoDTO);

    public

      Id: Variant;
      TopLevelApprovingId: Variant;
      PerformingDateTime: Variant;
      PerformingResultId: Variant;
      PerformingResultName: String;
      PerformingResultServiceName: String;
      IsAccessible: Boolean;
      Note: String;

      IsViewedByApprover: Boolean;

      constructor Create;

      function GetSelf: TObject;

      property ApproverInfoDTO: TDocumentFlowEmployeeInfoDTO
      read FApproverInfoDTO write SetApproverInfoDTO;

      property ActuallyPerformedEmployeeInfoDTO: TDocumentFlowEmployeeInfoDTO
      read FActuallyPerformedEmployeeInfoDTO write SetActuallyPerformedEmployeeInfoDTO;
          
  end;

  TDocumentApprovingsInfoDTO = class;

  TDocumentApprovingsInfoDTOEnumerator = class (TInterfaceListEnumerator)

    protected

      function GetCurrentDocumentApprovingInfoDTO: TDocumentApprovingInfoDTO;

    public

      constructor Create(DocumentApprovingsInfoDTO: TDocumentApprovingsInfoDTO);

      property Current: TDocumentApprovingInfoDTO
      read GetCurrentDocumentApprovingInfoDTO;
      
  end;

  TDocumentApprovingsInfoDTO = class (TInterfaceList, IGetSelf)

    protected

      function GetDocumentApprovingInfoDTOByIndex(
        Index: Integer
      ): TDocumentApprovingInfoDTO;

      procedure SetDocumentApprovingInfoDTOByIndex(
        Index: Integer;
        Value: TDocumentApprovingInfoDTO
      );

    public

      function GetSelf: TObject;
      
      function Add(DocumentApprovingInfoDTO: TDocumentApprovingInfoDTO): Integer;

      function FindByApprovingId(const ApprovingId: Variant): TDocumentApprovingInfoDTO;
    
      function GetEnumerator: TDocumentApprovingsInfoDTOEnumerator;

      property Items[Index: Integer]: TDocumentApprovingInfoDTO
      read GetDocumentApprovingInfoDTOByIndex
      write SetDocumentApprovingInfoDTOByIndex; default;
      
  end;

  TDocumentApprovingCycleResultInfoDTO = class (TInterfacedObject, IGetSelf)

    private

      FDocumentApprovingsInfoDTO: TDocumentApprovingsInfoDTO;
      FFreeDocumentApprovingsInfoDTO: IGetSelf;

      procedure SetDocumentApprovingsInfoDTO(
        const Value: TDocumentApprovingsInfoDTO);

    public

      Id: Variant;
      CycleNumber: Integer;

      function GetSelf: TObject;

      property DocumentApprovingsInfoDTO: TDocumentApprovingsInfoDTO
      read FDocumentApprovingsInfoDTO write SetDocumentApprovingsInfoDTO;

  end;

  TDocumentApprovingCycleResultsInfoDTO = class;

  TDocumentApprovingCycleResultsInfoDTOEnumerator = class (TInterfaceListEnumerator)

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

  TDocumentApprovingCycleResultsInfoDTO = class (TInterfaceList, IGetSelf)

    protected

      function GetDocumentApprovingCycleResultInfoDTOByIndex(
        Index: Integer
      ): TDocumentApprovingCycleResultInfoDTO;

      procedure SetDocumentApprovingCycleResultInfoDTOByIndex(
        Index: Integer;
        Value: TDocumentApprovingCycleResultInfoDTO
      );

    public

      function GetSelf: TObject;
      
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
  
  TDocumentSigningInfoDTO = class (TInterfacedObject, IGetSelf)

    private

      FSignerInfoDTO: TDocumentFlowEmployeeInfoDTO;
      FFreeSignerInfoDTO: IGetSelf;

      FActuallySignedEmployeeInfoDTO: TDocumentFlowEmployeeInfoDTO;
      FFreeActuallySignedEmployeeInfoDTO: IGetSelf;

      procedure SetActuallySignedEmployeeInfoDTO(
        const Value: TDocumentFlowEmployeeInfoDTO);

      procedure SetSignerInfoDTO(const Value: TDocumentFlowEmployeeInfoDTO);

    public

      Id: Variant;
      SigningDate: Variant;

      constructor Create;

      function GetSelf: TObject;

      property SignerInfoDTO: TDocumentFlowEmployeeInfoDTO
      read FSignerInfoDTO write SetSignerInfoDTO;

      property ActuallySignedEmployeeInfoDTO: TDocumentFlowEmployeeInfoDTO
      read FActuallySignedEmployeeInfoDTO write SetActuallySignedEmployeeInfoDTO;
      
  end;

  TDocumentSigningsInfoDTO = class;

  TDocumentSigningsInfoDTOEnumerator = class (TInterfaceListEnumerator)

    private

      function GetCurrentDocumentSigningInfoDTO:
        TDocumentSigningInfoDTO;

    public

      constructor Create(DocumentSigningsInfoDTO: TDocumentSigningsInfoDTO);

      property Current: TDocumentSigningInfoDTO
      read GetCurrentDocumentSigningInfoDTO;
      
  end;
  
  TDocumentSigningsInfoDTO = class (TInterfaceList, IGetSelf)

    private

      function GetDocumentSigningInfoDTOByIndex(
        Index: Integer
      ): TDocumentSigningInfoDTO;

      procedure SetDocumentSigningInfoDTOByIndex(
        Index: Integer;
        DocumentSigningInfoDTO: TDocumentSigningInfoDTO
      );

    public

      function GetSelf: TObject;
      
      function FindSigningInfoDTOById(const SigningId: Variant): TDocumentSigningInfoDTO;
      function FindSigningInfoDTOBySignerId(const SignerId: Variant): TDocumentSigningInfoDTO;
    
      function Add(DocumentSigningInfoDTO: TDocumentSigningInfoDTO): Integer;

      function GetEnumerator: TDocumentSigningsInfoDTOEnumerator;

      property Items[Index: Integer]: TDocumentSigningInfoDTO
      read GetDocumentSigningInfoDTOByIndex
      write SetDocumentSigningInfoDTOByIndex; default;
    
  end;

  TDocumentDTO = class (TInterfacedObject, IGetSelf)

    private

      FAuthorDTO: TDocumentFlowEmployeeInfoDTO;
      FFreeAuthorDTO: IGetSelf;
      
      FChargesInfoDTO: TDocumentChargesInfoDTO;
      FFreeChargesInfoDTO: IGetSelf;
      
      FApprovingsInfoDTO: TDocumentApprovingsInfoDTO;
      FFreeApprovingsInfoDTO: IGetSelf;
      
      FSigningsInfoDTO: TDocumentSigningsInfoDTO;
      FFreeSigningsInfoDTO: IGetSelf;
      
      FResponsibleInfoDTO: TDocumentResponsibleInfoDTO;
      FFreeResponsibleInfoDTO: IGetSelf;

    protected

      FId: Variant;
      FBaseDocumentId: Variant;
      FNumber: String;
      FSeparatorOfNumberParts: String;
      FName: String;
      FFullName: String;
      FContent: String;
      FCreationDate: TDateTime;
      FDocumentDate: Variant;
      FNote: String;
      FProductCode: String;
      FIsSelfRegistered: Variant;
      FKind: String;
      FKindId: Variant;

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
      function GetFullName: String; virtual;
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
      procedure SetFullName(const Value: String); virtual;
      procedure SetNote(const Value: String); virtual;
      procedure SetNumber(const Value: String); virtual;
      procedure SetResponsibleInfoDTO(const Value: TDocumentResponsibleInfoDTO); virtual;
      procedure SetSeparatorOfNumberParts(const Value: String); virtual;
      procedure SetSigningsInfoDTO(const Value: TDocumentSigningsInfoDTO); virtual;
      procedure SetIsSelfRegistered(const Value: Variant); virtual;
      
    public

      function GetSelf: TObject;
      
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

      property FullName: String
      read GetFullName write SetFullName;

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

  end;

  TDocumentFullInfoDTO = class (TInterfacedObject, IDisposable)

    private

      FDocumentDTO: TDocumentDTO;
      FFreeDocumentDTO: IGetSelf;
      
      FDocumentRelationsInfoDTO: TDocumentRelationsInfoDTO;
      FFreeDocumentRelationsInfoDTO: IGetSelf;
      
      FDocumentFilesInfoDTO: TDocumentFilesInfoDTO;
      FFreeDocumentFilesInfoDTO: IGetSelf;

      FDocumentApprovingCycleResultsInfoDTO: TDocumentApprovingCycleResultsInfoDTO;
      FFreeDocumentApprovingCycleResultsInfoDTO: IGetSelf;
      
      FDocumentChargeSheetsInfoDTO: TDocumentChargeSheetsInfoDTO;
      FFreeDocumentChargeSheetsInfoDTO: IGetSelf;

      procedure SetDocumentApprovingCycleResultsInfoDTO(
        const Value: TDocumentApprovingCycleResultsInfoDTO);

      procedure SetDocumentChargeSheetsInfoDTO(
        const Value: TDocumentChargeSheetsInfoDTO);

      procedure SetDocumentDTO(const Value: TDocumentDTO);
      procedure SetDocumentFilesInfoDTO(const Value: TDocumentFilesInfoDTO);
      procedure SetDocumentRelationsInfoDTO(
        const Value: TDocumentRelationsInfoDTO);  public

    public
    
      property DocumentDTO: TDocumentDTO
      read FDocumentDTO write SetDocumentDTO;
      
      property DocumentRelationsInfoDTO: TDocumentRelationsInfoDTO
      read FDocumentRelationsInfoDTO write SetDocumentRelationsInfoDTO;

      property DocumentFilesInfoDTO: TDocumentFilesInfoDTO
      read FDocumentFilesInfoDTO write SetDocumentFilesInfoDTO;

      property DocumentApprovingCycleResultsInfoDTO: TDocumentApprovingCycleResultsInfoDTO
      read FDocumentApprovingCycleResultsInfoDTO write SetDocumentApprovingCycleResultsInfoDTO;
      
      property DocumentChargeSheetsInfoDTO: TDocumentChargeSheetsInfoDTO
      read FDocumentChargeSheetsInfoDTO write SetDocumentChargeSheetsInfoDTO;

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
var
    Intf: IInterface;
    Target: IGetSelf;
begin

  Intf := GetCurrent;
  
  Supports(Intf, IGetSelf, Target);
                     
  Result := TDocumentRelationInfoDTO(Target.Self);
  
end;

{ TDocumentRelationsInfoDTO }

function TDocumentRelationsInfoDTO.Add(
  DocumentRelationInfoDTO: TDocumentRelationInfoDTO): Integer;
begin

  Result := inherited Add(DocumentRelationInfoDTO);
  
end;

function TDocumentRelationsInfoDTO.GetDocumentRelationInfoDTOByIndex(
  Index: Integer): TDocumentRelationInfoDTO;
var
    Intf: IInterface;
    Target: IGetSelf; 
begin

  Intf := Get(Index);

  Supports(Intf, IGetSelf, Target);

  Result := TDocumentRelationInfoDTO(Target.Self);
  
end;

function TDocumentRelationsInfoDTO.GetEnumerator: TDocumentRelationsInfoDTOEnumerator;
begin

  Result := TDocumentRelationsInfoDTOEnumerator.Create(Self);
  
end;

function TDocumentRelationsInfoDTO.GetSelf: TObject;
begin

  Result := Self;
  
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
var
    Intf: IInterface;
    Target: IGetSelf;
begin

  Intf := GetCurrent;

  Supports(Intf, IGetSelf, Target);
  
  Result := TDocumentFileInfoDTO(Target.Self);
  
end;

{ TDocumentFilesInfoDTO }

function TDocumentFilesInfoDTO.Add(
  DocumentFileInfoDTO: TDocumentFileInfoDTO): Integer;
begin

  Result := inherited Add(DocumentFileInfoDTO);

end;

function TDocumentFilesInfoDTO.GetDocumentFileInfoDTOByIndex(
  Index: Integer): TDocumentFileInfoDTO;
var
    Intf: IInterface;
    Target: IGetSelf;
begin

  Intf := Get(Index);

  Supports(Intf, IGetSelf, Target);

  Result := TDocumentFileInfoDTO(Target.Self);

end;

function TDocumentFilesInfoDTO.GetEnumerator: TDocumentFilesInfoDTOEnumerator;
begin

  Result := TDocumentFilesInfoDTOEnumerator.Create(Self);
  
end;

function TDocumentFilesInfoDTO.GetSelf: TObject;
begin

  Result := Self;
  
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

{ TDocumentDTO }

constructor TDocumentDTO.Create;
begin

  inherited;

  FId := Null;
  FBaseDocumentId := Null;
  FIsSelfRegistered := Null;
  FDocumentDate := Null;
  
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

function TDocumentDTO.GetFullName: String;
begin

  Result := FFullName;
  
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

function TDocumentDTO.GetSelf: TObject;
begin

  Result := Self;
  
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
  FFreeApprovingsInfoDTO := Value;

end;

procedure TDocumentDTO.SetAuthorDTO(const Value: TDocumentFlowEmployeeInfoDTO);
begin

  FAuthorDTO := Value;
  FFreeAuthorDTO := Value;
  
end;

procedure TDocumentDTO.SetBaseDocumentId(const Value: Variant);
begin

  FBaseDocumentId := Value;
  
end;

procedure TDocumentDTO.SetChargesInfoDTO(const Value: TDocumentChargesInfoDTO);
begin

  FChargesInfoDTO := Value;
  FFreeChargesInfoDTO := Value;

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

procedure TDocumentDTO.SetFullName(const Value: String);
begin

  FFullName := Value;
  
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
  FFreeResponsibleInfoDTO := Value;
  
end;

procedure TDocumentDTO.SetSeparatorOfNumberParts(const Value: String);
begin

  FSeparatorOfNumberParts := Value;

end;

procedure TDocumentDTO.SetSigningsInfoDTO(
  const Value: TDocumentSigningsInfoDTO);
begin

  FSigningsInfoDTO := Value;
  FFreeSigningsInfoDTO := Value;
  
end;

{ TDocumentFullInfoDTO }

procedure TDocumentFullInfoDTO.SetDocumentApprovingCycleResultsInfoDTO(
  const Value: TDocumentApprovingCycleResultsInfoDTO);
begin

  FDocumentApprovingCycleResultsInfoDTO := Value;
  FFreeDocumentApprovingCycleResultsInfoDTO := Value;

end;

procedure TDocumentFullInfoDTO.SetDocumentChargeSheetsInfoDTO(
  const Value: TDocumentChargeSheetsInfoDTO);
begin

  FDocumentChargeSheetsInfoDTO := Value;
  FFreeDocumentChargeSheetsInfoDTO := Value;
  
end;

procedure TDocumentFullInfoDTO.SetDocumentDTO(const Value: TDocumentDTO);
begin

  FDocumentDTO := Value;
  FFreeDocumentDTO := Value;

end;

procedure TDocumentFullInfoDTO.SetDocumentFilesInfoDTO(
  const Value: TDocumentFilesInfoDTO);
begin

  FDocumentFilesInfoDTO := Value;
  FFreeDocumentFilesInfoDTO := Value;

end;

procedure TDocumentFullInfoDTO.SetDocumentRelationsInfoDTO(
  const Value: TDocumentRelationsInfoDTO);
begin

  FDocumentRelationsInfoDTO := Value;
  FFreeDocumentRelationsInfoDTO := Value;

end;

{ TDocumentSigningsInfoDTOEnumerator }

constructor TDocumentSigningsInfoDTOEnumerator.Create(
  DocumentSigningsInfoDTO: TDocumentSigningsInfoDTO);
begin

  inherited Create(DocumentSigningsInfoDTO);
  
end;

function TDocumentSigningsInfoDTOEnumerator.GetCurrentDocumentSigningInfoDTO: TDocumentSigningInfoDTO;
var
    Intf: IInterface;
    Target: IGetSelf;
begin

  Intf := GetCurrent;

  Supports(Intf, IGetSelf, Target);

  Result := TDocumentSigningInfoDTO(Target.Self);

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
var
    Intf: IInterface;
    Target: IGetSelf;
begin

  Intf := Get(Index);

  Supports(Intf, IGetSelf, Target);

  Result := TDocumentSigningInfoDTO(Target.Self);
  
end;

function TDocumentSigningsInfoDTO.GetEnumerator: TDocumentSigningsInfoDTOEnumerator;
begin

  Result := TDocumentSigningsInfoDTOEnumerator.Create(Self);
  
end;

function TDocumentSigningsInfoDTO.GetSelf: TObject;
begin

  Result := Self;
  
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

function TDocumentSigningInfoDTO.GetSelf: TObject;
begin

  Result := Self;
  
end;

 procedure TDocumentSigningInfoDTO.SetActuallySignedEmployeeInfoDTO(
  const Value: TDocumentFlowEmployeeInfoDTO);
begin

  FActuallySignedEmployeeInfoDTO := Value;
  FFreeActuallySignedEmployeeInfoDTO := Value;
  
end;

procedure TDocumentSigningInfoDTO.SetSignerInfoDTO(
  const Value: TDocumentFlowEmployeeInfoDTO);
begin

  FSignerInfoDTO := Value;

end;

{ TDocumentFileInfoDTO }

constructor TDocumentFileInfoDTO.Create;
begin

  inherited;

  Id := Null;
  DocumentId := Null;
  
end;

function TDocumentFileInfoDTO.GetSelf: TObject;
begin

  Result := Self;
  
end;

{ TDocumentRelationInfoDTO }

constructor TDocumentRelationInfoDTO.Create;
begin

  inherited;

  TargetDocumentId := Null;
  RelatedDocumentId := Null;
  RelatedDocumentKindId := Null;
  
end;

function TDocumentRelationInfoDTO.GetSelf: TObject;
begin

  Result := Self;
  
end;

{ TDocumentApprovingInfoDTO }

constructor TDocumentApprovingInfoDTO.Create;
begin

  inherited;

  Id := Null;
  TopLevelApprovingId := Null;
  PerformingDateTime := Null;

end;

function TDocumentApprovingInfoDTO.GetSelf: TObject;
begin

  Result := Self;
  
end;

procedure TDocumentApprovingInfoDTO.SetActuallyPerformedEmployeeInfoDTO(
  const Value: TDocumentFlowEmployeeInfoDTO);
begin

  FActuallyPerformedEmployeeInfoDTO := Value;
  FFreeActuallyPerformedEmployeeInfoDTO := Value;
  
end;

procedure TDocumentApprovingInfoDTO.SetApproverInfoDTO(
  const Value: TDocumentFlowEmployeeInfoDTO);
begin

  FApproverInfoDTO := Value;
  FFreeApproverInfoDTO := Value;
  
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
var
    Intf: IInterface;
    Target: IGetSelf;
begin

  Intf := Get(Index);

  Supports(Intf, IGetSelf, Target);

  Result := TDocumentApprovingInfoDTO(Target.Self);
  
end;

function TDocumentApprovingsInfoDTO.GetEnumerator: TDocumentApprovingsInfoDTOEnumerator;
begin

  Result := TDocumentApprovingsInfoDTOEnumerator.Create(Self);
  
end;

function TDocumentApprovingsInfoDTO.GetSelf: TObject;
begin

  Result := Self;
  
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
var
    Intf: IInterface;
    Target: IGetSelf;
begin

  Intf := GetCurrent;

  Supports(Intf, IGetSelf, Target);

  Result := TDocumentApprovingInfoDTO(Target.Self);
  
end;

{ TDocumentApprovingCycleResultInfoDTO }

function TDocumentApprovingCycleResultInfoDTO.GetSelf: TObject;
begin

  Result := Self;
  
end;

procedure TDocumentApprovingCycleResultInfoDTO.SetDocumentApprovingsInfoDTO(
  const Value: TDocumentApprovingsInfoDTO);
begin

  FDocumentApprovingsInfoDTO := Value;
  FFreeDocumentApprovingsInfoDTO := Value;
  
end;

{ TDocumentApprovingCycleResultsInfoDTOEnumerator }

constructor TDocumentApprovingCycleResultsInfoDTOEnumerator.Create(
  DocumentApprovingCycleResultsInfoDTO: TDocumentApprovingCycleResultsInfoDTO);
begin

  inherited Create(DocumentApprovingCycleResultsInfoDTO);
  
end;

function TDocumentApprovingCycleResultsInfoDTOEnumerator.GetCurrentDocumentApprovingCycleResultInfoDTO: TDocumentApprovingCycleResultInfoDTO;
var
    Intf: IInterface;
    Target: IGetSelf;
begin

  Intf := GetCurrent;

  Supports(Intf, IGetSelf, Target);

  Result := TDocumentApprovingCycleResultInfoDTO(Target.Self);

  
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
var
    Intf: IInterface;
    Target: IGetSelf;
begin

  Intf := Get(Index);

  Supports(Intf, IGetSelf, Target);

  Result := TDocumentApprovingCycleResultInfoDTO(Target.Self);
  
end;

function TDocumentApprovingCycleResultsInfoDTO.GetEnumerator: TDocumentApprovingCycleResultsInfoDTOEnumerator;
begin

  Result := TDocumentApprovingCycleResultsInfoDTOEnumerator.Create(Self);
  
end;

function TDocumentApprovingCycleResultsInfoDTO.GetSelf: TObject;
begin

  Result := Self;
  
end;

procedure TDocumentApprovingCycleResultsInfoDTO.SetDocumentApprovingCycleResultInfoDTOByIndex(
  Index: Integer; Value: TDocumentApprovingCycleResultInfoDTO);
begin

  Put(Index, Value);
  
end;

end.

