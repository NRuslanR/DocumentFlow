unit DocumentChargeSheetsInfoDTO;

interface

uses

  EmployeeInfoDTO,
  DocumentFlowEmployeeInfoDTO,
  DepartmentInfoDTO,
  VariantListUnit,
  SysUtils,
  IGetSelfUnit,
  Classes;

type

  TDocumentChargeAccessRightsDTO = class

    public

      ChargeSectionAccessible: Variant;
      RemovingAllowed: Variant;

      constructor Create;
      
  end;

  TDocumentChargeInfoDTO = class (TInterfacedObject, IGetSelf)

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

      function GetSelf: TObject;
      
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

  TDocumentChargesInfoDTOEnumerator = class (TInterfaceListEnumerator)

    strict private

      function GetCurrentDocumentChargeInfoDTO: TDocumentChargeInfoDTO;

    public

      constructor Create(DocumentChargesInfoDTO: TDocumentChargesInfoDTO);

      property Current: TDocumentChargeInfoDTO
      read GetCurrentDocumentChargeInfoDTO;

  end;

  TDocumentChargesInfoDTO = class (TInterfaceList, IGetSelf)

    strict private

      function GetDocumentChargeInfoDTOByIndex(
        Index: Integer
      ): TDocumentChargeInfoDTO;

      procedure SetDocumentChargeInfoDTOByIndex(
        Index: Integer;
        DocumentChargeInfoDTO: TDocumentChargeInfoDTO
      );

    public

      function GetSelf: TObject;
      
      function ExtractPerformerIds: TVariantList;

      function FindChargeByPerformerId(const PerformerId: Variant): TDocumentChargeInfoDTO;
      
      function Add(DocumentChargeInfoDTO: TDocumentChargeInfoDTO): Integer;
      procedure Remove(const Index: Integer);

      function GetEnumerator: TDocumentChargesInfoDTOEnumerator;

      property Items[Index: Integer]: TDocumentChargeInfoDTO
      read GetDocumentChargeInfoDTOByIndex
      write SetDocumentChargeInfoDTOByIndex; default;

  end;

  TDocumentChargeSheetAccessRightsDTO = class

    public

      ViewingAllowed: Variant;
      ChargeSectionAccessible: Variant;
      ResponseSectionAccessible: Variant;
      RemovingAllowed: Variant;
      PerformingAllowed: Variant;
      IsEmployeePerformer: Variant;
      SubordinateChargeSheetsIssuingAllowed: Variant;
      
      constructor Create;
      
  end;

  TDocumentChargeSheetInfoDTO = class (TInterfacedObject, IGetSelf)

    private

      function GetActuallyPerformedEmployeeInfoDTO: TDocumentFlowEmployeeInfoDTO;
      function GetChargeId: Variant;
      function GetChargeText: String;
      function GetIsForAcquaitance: Boolean;
      function GetKindId: Variant;
      function GetKindName: String;
      function GetPerformerInfoDTO: TDocumentFlowEmployeeInfoDTO;
      function GetPerformerResponse: String;
      function GetPerformingDateTime: Variant;
      function GetServiceKindName: String;
      function GetTimeFrameDeadline: Variant;
      function GetTimeFrameStart: Variant;

      procedure SetActuallyPerformedEmployeeInfoDTO(
        const Value: TDocumentFlowEmployeeInfoDTO);
        
      procedure SetChargeId(const Value: Variant);
      procedure SetChargeText(const Value: String);
      procedure SetIsForAcquaitance(const Value: Boolean);
      procedure SetKindId(const Value: Variant);
      procedure SetKindName(const Value: String);
      procedure SetPerformerInfoDTO(const Value: TDocumentFlowEmployeeInfoDTO);
      procedure SetPerformerResponse(const Value: String);
      procedure SetPerformingDateTime(const Value: Variant);
      procedure SetServiceKindName(const Value: String);
      procedure SetTimeFrameDeadline(const Value: Variant);
      procedure SetTimeFrameStart(const Value: Variant);
      procedure SetChargeInfoDTO(const Value: TDocumentChargeInfoDTO);

    protected

      FChargeInfoDTO: TDocumentChargeInfoDTO;
      FFreeChargeInfoDTO: IInterface;

      function CreateChargeInfoDTOInstance: TDocumentChargeInfoDTO; virtual;
      function CreateAccessRightsDTOInstance: TDocumentChargeSheetAccessRightsDTO; virtual;
      
    public
      
      Id: Variant;

      TopLevelChargeSheetId: Variant;
      DocumentId: Variant;
      DocumentKindId: Variant;

      IssuingDateTime: Variant;

      ViewDateByPerformer: Variant;

      AccessRights: TDocumentChargeSheetAccessRightsDTO;

      IssuerInfoDTO: TDocumentFlowEmployeeInfoDTO;

    public

      IsChargeTextChanged: Boolean;
      IsPerformerResponseChanged: Boolean;
      
    public

      constructor Create;
      destructor Destroy; override;

      function GetSelf: TObject;

      property ChargeInfoDTO: TDocumentChargeInfoDTO
      read FChargeInfoDTO write SetChargeInfoDTO;
      
      property ChargeId: Variant read GetChargeId write SetChargeId;
      property KindId: Variant read GetKindId write SetKindId;
      property KindName: String read GetKindName write SetKindName;
      property ServiceKindName: String read GetServiceKindName write SetServiceKindName;
      property ChargeText: String read GetChargeText write SetChargeText;
      property PerformerResponse: String read GetPerformerResponse write SetPerformerResponse;
      property TimeFrameStart: Variant read GetTimeFrameStart write SetTimeFrameStart;
      property TimeFrameDeadline: Variant read GetTimeFrameDeadline write SetTimeFrameDeadline;
      property PerformingDateTime: Variant read GetPerformingDateTime write SetPerformingDateTime;
      property IsForAcquaitance: Boolean read GetIsForAcquaitance write SetIsForAcquaitance;
      
      property PerformerInfoDTO: TDocumentFlowEmployeeInfoDTO
      read GetPerformerInfoDTO write SetPerformerInfoDTO;

      property ActuallyPerformedEmployeeInfoDTO: TDocumentFlowEmployeeInfoDTO
      read GetActuallyPerformedEmployeeInfoDTO write SetActuallyPerformedEmployeeInfoDTO;

  end;

  TDocumentChargeSheetInfoDTOClass = class of TDocumentChargeSheetInfoDTO;
  
  TDocumentAcquaitanceSheetInfoDTO = class (TDocumentChargeSheetInfoDTO)

    function CreateChargeInfoDTOInstance: TDocumentChargeInfoDTO; override;
    
  end;

  TDocumentPerformingSheetInfoDTO = class (TDocumentChargeSheetInfoDTO)

    function CreateChargeInfoDTOInstance: TDocumentChargeInfoDTO; override;

  end;
  
  TDocumentChargeSheetsInfoDTO = class;
  
  TDocumentChargeSheetsInfoDTOEnumerator = class (TInterfaceListEnumerator)

    private

      function GetCurrentDocumentChargeSheetInfoDTO:
        TDocumentChargeSheetInfoDTO;

    public

      constructor Create(
        DocumentChargeSheetsInfoDTO: TDocumentChargeSheetsInfoDTO
      );

      property Current: TDocumentChargeSheetInfoDTO
      read GetCurrentDocumentChargeSheetInfoDTO;
      
  end;

  TDocumentChargeSheetsInfoDTO = class (TInterfaceList, IGetSelf)

    private

      function GetDocumentChargeSheetInfoDTOByIndex(
        Index: Integer
      ): TDocumentChargeSheetInfoDTO;

      procedure SetDocumentChargeSheetInfoDTOByIndex(
        Index: Integer;
        DocumentChargeSheetInfoDTO: TDocumentChargeSheetInfoDTO
      );

    public

      function GetSelf: TObject;
      
      function Add(
        DocumentChargeSheetInfoDTO: TDocumentChargeSheetInfoDTO
      ): Integer;

      function ExtractChargesInfoDTO: TDocumentChargesInfoDTO;

      function FindById(const DocumentChargeSheetId: Variant): TDocumentChargeSheetInfoDTO;
      
      function GetEnumerator: TDocumentChargeSheetsInfoDTOEnumerator;

      property Items[Index: Integer]: TDocumentChargeSheetInfoDTO
      read GetDocumentChargeSheetInfoDTOByIndex
      write SetDocumentChargeSheetInfoDTOByIndex; default;
  
  end;

implementation

uses

  Variants;

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

function TDocumentChargeInfoDTO.GetSelf: TObject;
begin

  Result := Self;
  
end;

procedure TDocumentChargeInfoDTO.SetAccessRights(
  const Value: TDocumentChargeAccessRightsDTO);
begin

  if FAccessRights = Value then Exit;

  FreeAndNil(FAccessRights);
  
  FAccessRights := Value;

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


{ TDocumentChargesInfoDTOEnumerator }

constructor TDocumentChargesInfoDTOEnumerator.Create(
  DocumentChargesInfoDTO: TDocumentChargesInfoDTO);
begin

  inherited Create(DocumentChargesInfoDTO);
  
end;

function TDocumentChargesInfoDTOEnumerator.GetCurrentDocumentChargeInfoDTO: TDocumentChargeInfoDTO;
var
    CurrentInterface: IInterface;
    SelfInterface: IGetSelf;
begin

  CurrentInterface := GetCurrent;

  Supports(CurrentInterface, IGetSelf, SelfInterface);

  Result := TDocumentChargeInfoDTO(SelfInterface.Self);
  
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

  Result := TDocumentChargeInfoDTO(IGetSelf(Get(Index)).Self);
  
end;

function TDocumentChargesInfoDTO.GetEnumerator: TDocumentChargesInfoDTOEnumerator;
begin

  Result := TDocumentChargesInfoDTOEnumerator.Create(Self);
  
end;

function TDocumentChargesInfoDTO.GetSelf: TObject;
begin

  Result := Self;
  
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

{ TDocumentChargeSheetsInfoDTOEnumerator }

constructor TDocumentChargeSheetsInfoDTOEnumerator.Create(
  DocumentChargeSheetsInfoDTO: TDocumentChargeSheetsInfoDTO);
begin

  inherited Create(DocumentChargeSheetsInfoDTO);
  
end;

function TDocumentChargeSheetsInfoDTOEnumerator
  .GetCurrentDocumentChargeSheetInfoDTO: TDocumentChargeSheetInfoDTO;
var
    CurrentIntf: IInterface;
    SelfIntf: IGetSelf;
begin

  CurrentIntf := GetCurrent;

  Supports(CurrentIntf, IGetSelf, SelfIntf);

  Result := TDocumentChargeSheetInfoDTO(SelfIntf.Self);
  
end;

{ TDocumentChargeSheetsInfoDTO }

function TDocumentChargeSheetsInfoDTO.Add(
  DocumentChargeSheetInfoDTO: TDocumentChargeSheetInfoDTO
): Integer;
begin

  Result := inherited Add(DocumentChargeSheetInfoDTO);

end;

function TDocumentChargeSheetsInfoDTO.ExtractChargesInfoDTO: TDocumentChargesInfoDTO;
var
    ChargeSheetInfoDTO: TDocumentChargeSheetInfoDTO;
begin

  Result := TDocumentChargesInfoDTO.Create;

  try

    for ChargeSheetInfoDTO in Self do
      Result.Add(ChargeSheetInfoDTO.ChargeInfoDTO);

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

function TDocumentChargeSheetsInfoDTO.FindById(
  const DocumentChargeSheetId: Variant): TDocumentChargeSheetInfoDTO;
begin

  for Result in Self do
    if Result.Id = DocumentChargeSheetId then
      Exit;

  Result := nil;

end;

function TDocumentChargeSheetsInfoDTO.GetDocumentChargeSheetInfoDTOByIndex(
  Index: Integer): TDocumentChargeSheetInfoDTO;
begin

  Result := TDocumentChargeSheetInfoDTO(IGetSelf(Get(Index)).Self);
  
end;

function TDocumentChargeSheetsInfoDTO.GetEnumerator: TDocumentChargeSheetsInfoDTOEnumerator;
begin

  Result := TDocumentChargeSheetsInfoDTOEnumerator.Create(Self);
  
end;

function TDocumentChargeSheetsInfoDTO.GetSelf: TObject;
begin

  Result := Self;
  
end;

procedure TDocumentChargeSheetsInfoDTO.SetDocumentChargeSheetInfoDTOByIndex(
  Index: Integer; DocumentChargeSheetInfoDTO: TDocumentChargeSheetInfoDTO);
begin

  Put(Index, DocumentChargeSheetInfoDTO);
  
end;

{ TDocumentChargeSheetInfoDTO }

constructor TDocumentChargeSheetInfoDTO.Create;
begin

  inherited;

  Id := Null;
  DocumentKindId := Null;
  TopLevelChargeSheetId := Null;
  DocumentId := Null;
  IssuingDateTime := Null;
  ViewDateByPerformer := Null;

  FChargeInfoDTO := CreateChargeInfoDTOInstance;
  AccessRights := CreateAccessRightsDTOInstance;
  IssuerInfoDTO := TDocumentFlowEmployeeInfoDTO.Create;
  
end;

function TDocumentChargeSheetInfoDTO.CreateAccessRightsDTOInstance: TDocumentChargeSheetAccessRightsDTO;
begin

  Result := TDocumentChargeSheetAccessRightsDTO.Create;

end;

function TDocumentChargeSheetInfoDTO.CreateChargeInfoDTOInstance: TDocumentChargeInfoDTO;
begin

  Result := TDocumentChargeInfoDTO.Create;

end;

function TDocumentChargeSheetInfoDTO.GetActuallyPerformedEmployeeInfoDTO: TDocumentFlowEmployeeInfoDTO;
begin

  Result := FChargeInfoDTO.ActuallyPerformedEmployeeInfoDTO;

end;

function TDocumentChargeSheetInfoDTO.GetChargeId: Variant;
begin

  Result := FChargeInfoDTO.Id;

end;

function TDocumentChargeSheetInfoDTO.GetChargeText: String;
begin

  Result := FChargeInfoDTO.ChargeText;

end;

function TDocumentChargeSheetInfoDTO.GetIsForAcquaitance: Boolean;
begin

  Result := FChargeInfoDTO.IsForAcquaitance;

end;

function TDocumentChargeSheetInfoDTO.GetKindId: Variant;
begin

  Result := FChargeInfoDTO.KindId;

end;

function TDocumentChargeSheetInfoDTO.GetKindName: String;
begin

  Result := FChargeInfoDTO.KindName;

end;

function TDocumentChargeSheetInfoDTO.GetPerformerInfoDTO: TDocumentFlowEmployeeInfoDTO;
begin

  Result := FChargeInfoDTO.PerformerInfoDTO;

end;

function TDocumentChargeSheetInfoDTO.GetPerformerResponse: String;
begin

  Result := FChargeInfoDTO.PerformerResponse;

end;

function TDocumentChargeSheetInfoDTO.GetPerformingDateTime: Variant;
begin

  Result := FChargeInfoDTO.PerformingDateTime;
  
end;

function TDocumentChargeSheetInfoDTO.GetSelf: TObject;
begin

  Result := Self;
  
end;

function TDocumentChargeSheetInfoDTO.GetServiceKindName: String;
begin

  Result := FChargeInfoDTO.ServiceKindName;
  
end;

function TDocumentChargeSheetInfoDTO.GetTimeFrameDeadline: Variant;
begin

  Result := FChargeInfoDTO.TimeFrameDeadline;
  
end;

function TDocumentChargeSheetInfoDTO.GetTimeFrameStart: Variant;
begin

  Result := FChargeInfoDTO.TimeFrameStart;
  
end;

procedure TDocumentChargeSheetInfoDTO.SetActuallyPerformedEmployeeInfoDTO(
  const Value: TDocumentFlowEmployeeInfoDTO);
begin

  FChargeInfoDTO.ActuallyPerformedEmployeeInfoDTO := Value;
  
end;

procedure TDocumentChargeSheetInfoDTO.SetChargeId(const Value: Variant);
begin

  FChargeInfoDTO.Id := Value;
  
end;

procedure TDocumentChargeSheetInfoDTO.SetChargeInfoDTO(
  const Value: TDocumentChargeInfoDTO);
begin

  FChargeInfoDTO := Value;
  FFreeChargeInfoDTO := Value;

end;

procedure TDocumentChargeSheetInfoDTO.SetChargeText(const Value: String);
begin

  FChargeInfoDTO.ChargeText := Value;
  
end;

procedure TDocumentChargeSheetInfoDTO.SetIsForAcquaitance(const Value: Boolean);
begin

  FChargeInfoDTO.IsForAcquaitance := Value;
  
end;

procedure TDocumentChargeSheetInfoDTO.SetKindId(const Value: Variant);
begin

  FChargeInfoDTO.KindId := Value;

end;

procedure TDocumentChargeSheetInfoDTO.SetKindName(const Value: String);
begin

  FChargeInfoDTO.KindName := Value;
  
end;

procedure TDocumentChargeSheetInfoDTO.SetPerformerInfoDTO(
  const Value: TDocumentFlowEmployeeInfoDTO);
begin

  FChargeInfoDTO.PerformerInfoDTO := Value;
  
end;

procedure TDocumentChargeSheetInfoDTO.SetPerformerResponse(const Value: String);
begin

  FChargeInfoDTO.PerformerResponse := Value;
  
end;

procedure TDocumentChargeSheetInfoDTO.SetPerformingDateTime(
  const Value: Variant);
begin

  FChargeInfoDTO.PerformingDateTime := Value;
  
end;

procedure TDocumentChargeSheetInfoDTO.SetServiceKindName(const Value: String);
begin

  FChargeInfoDTO.ServiceKindName := Value;
  
end;

procedure TDocumentChargeSheetInfoDTO.SetTimeFrameDeadline(
  const Value: Variant);
begin

  FChargeInfoDTO.TimeFrameDeadline := Value;

end;

procedure TDocumentChargeSheetInfoDTO.SetTimeFrameStart(const Value: Variant);
begin

  FChargeInfoDTO.TimeFrameStart := Value;

end;

destructor TDocumentChargeSheetInfoDTO.Destroy;
begin

  FreeAndNil(IssuerInfoDTO);
  FreeAndNil(AccessRights);
  
  inherited;

end;

{ TDocumentPerformingSheetInfoDTO }

function TDocumentPerformingSheetInfoDTO.CreateChargeInfoDTOInstance: TDocumentChargeInfoDTO;
begin

  Result := TDocumentPerformingInfoDTO.Create;
  
end;

{ TDocumentAcquaitanceSheetInfoDTO }

function TDocumentAcquaitanceSheetInfoDTO.CreateChargeInfoDTOInstance: TDocumentChargeInfoDTO;
begin

  Result := TDocumentAcquaitanceInfoDTO.Create;
  
end;

{ TDocumentChargeSheetAccessRightsDTO }

constructor TDocumentChargeSheetAccessRightsDTO.Create;
begin

  inherited;

  ViewingAllowed := Null;
  ChargeSectionAccessible := Null;
  ResponseSectionAccessible := Null;
  RemovingAllowed := Null;
  PerformingAllowed := Null;
  
end;

end.

