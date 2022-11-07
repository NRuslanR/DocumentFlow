unit DocumentStorageServiceCommandsAndRespones;

interface

uses

  VariantListUnit,
  DocumentFullInfoDTO,
  NewDocumentInfoDTO,
  ChangedDocumentInfoDTO,
  Disposable,
  DocumentUsageEmployeeAccessRightsInfoDTO,
  DocumentApprovingListDTO,
  DocumentFlowEmployeeInfoDTO,
  SysUtils,
  Classes;
  
type

  IDocumentStorageServiceCommand = interface

  end;

  TDocumentStorageServiceCommand = class (TInterfacedObject, IDocumentStorageServiceCommand)

  end;

  IDocumentCreatingCommand = interface (IDocumentStorageServiceCommand)

    function GetEmployeeId: Variant;
    procedure SetEmployeeId(const Value: Variant);

    property EmployeeId: Variant read GetEmployeeId write SetEmployeeId;

  end;

  TDocumentCreatingCommand =
    class (TDocumentStorageServiceCommand, IDocumentCreatingCommand)

      private

        FEmployeeId: Variant;

      private

        function GetEmployeeId: Variant;
        procedure SetEmployeeId(const Value: Variant);

      public

        constructor Create(const EmployeeId: Variant);

        property EmployeeId: Variant read GetEmployeeId write SetEmployeeId;

    end;

  IDocumentCreatingCommandResult = interface

    function GetDocumentFullInfoDTO: TDocumentFullInfoDTO;
    procedure SetDocumentFullInfoDTO(const Value: TDocumentFullInfoDTO);

    function GetDocumentAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO;
    procedure SetDocumentAccessRightsInfoDTO(const Value: TDocumentUsageEmployeeAccessRightsInfoDTO);

    property DocumentFullInfoDTO: TDocumentFullInfoDTO
    read GetDocumentFullInfoDTO write SetDocumentFullInfoDTO;

    property DocumentAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO
    read GetDocumentAccessRightsInfoDTO write SetDocumentAccessRightsInfoDTO;

  end;

  TDocumentCreatingCommandResult =
    class (TInterfacedObject, IDocumentCreatingCommandResult)

      private

        FDocumentFullInfoDTO: TDocumentFullInfoDTO;
        FFreeDocumentFullInfoDTO: IDisposable;

        FDocumentAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO;
        FFreeDocumentAccessRightsInfoDTO: IDocumentUsageEmployeeAccessRightsInfoDTO;

      public

        constructor Create(
          DocumentFullInfoDTO: TDocumentFullInfoDTO;
          DocumentAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO
        );

        function GetDocumentFullInfoDTO: TDocumentFullInfoDTO;
        procedure SetDocumentFullInfoDTO(const Value: TDocumentFullInfoDTO);

        function GetDocumentAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO;
        procedure SetDocumentAccessRightsInfoDTO(const Value: TDocumentUsageEmployeeAccessRightsInfoDTO);

        property DocumentFullInfoDTO: TDocumentFullInfoDTO
        read GetDocumentFullInfoDTO write SetDocumentFullInfoDTO;

        property DocumentAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO
        read GetDocumentAccessRightsInfoDTO write SetDocumentAccessRightsInfoDTO;

    end;

  TGettingDocumentFullInfoCommand = class (TInterfacedObject, IDocumentStorageServiceCommand)

    private

      FDocumentId: Variant;
      FRequestingEmployeeId: Variant;

    public

      constructor Create(
        DocumentId: Variant;
        RequestingEmployeeId: Variant
      );

    published

      property DocumentId: Variant read FDocumentId;
      property RequestingEmployeeId: Variant read FRequestingEmployeeId;

  end;

  IGettingDocumentFullInfoCommandResult = interface

    function GetDocumentFullInfoDTO: TDocumentFullInfoDTO;
    function GetDocumentUsageEmployeeAccessRightsInfoDTO: IDocumentUsageEmployeeAccessRightsInfoDTO;
  
    property DocumentFullInfoDTO: TDocumentFullInfoDTO
    read GetDocumentFullInfoDTO;

    property DocumentUsageEmployeeAccessRightsInfoDTO: IDocumentUsageEmployeeAccessRightsInfoDTO
    read GetDocumentUsageEmployeeAccessRightsInfoDTO;

  end;

  TGettingDocumentFullInfoCommandResult =
    class (TDocumentStorageServiceCommand, IGettingDocumentFullInfoCommandResult)

      private

        FDocumentFullInfoDTO: TDocumentFullInfoDTO;
        FDocumentUsageEmployeeAccessRightsInfoDTO: IDocumentUsageEmployeeAccessRightsInfoDTO;

        function GetDocumentFullInfoDTO: TDocumentFullInfoDTO;
        function GetDocumentUsageEmployeeAccessRightsInfoDTO: IDocumentUsageEmployeeAccessRightsInfoDTO;

      public

        destructor Destroy; override;
        constructor Create(
          DocumentFullInfoDTO: TDocumentFullInfoDTO;
          DocumentUsageEmployeeAccessRightsInfoDTO: IDocumentUsageEmployeeAccessRightsInfoDTO
        );

      published

        property DocumentFullInfoDTO: TDocumentFullInfoDTO
        read GetDocumentFullInfoDTO;

        property DocumentUsageEmployeeAccessRightsInfoDTO: IDocumentUsageEmployeeAccessRightsInfoDTO
        read GetDocumentUsageEmployeeAccessRightsInfoDTO;

    end;

  TAddNewDocumentFullInfoCommand =
    class (TDocumentStorageServiceCommand, IDocumentStorageServiceCommand)

      private

        FCreatingNewDocumentEmployeeId: Variant;
        FNewDocumentInfoDTO: TNewDocumentInfoDTO;

      public

        destructor Destroy; override;
        constructor Create(
          const CreatingNewDocumentEmployeeId: Variant;
          NewDocumentInfoDTO: TNewDocumentInfoDTO
        );

      published

        property NewDocumentInfoDTO: TNewDocumentInfoDTO
        read FNewDocumentInfoDTO;

        property CreatingNewDocumentEmployeeId: Variant
        read FCreatingNewDocumentEmployeeId;

    end;

  IAddNewDocumentFullInfoCommandResult = interface

    function GetNewDocumentId: Variant;
    function GetCurrentNewDocumentWorkCycleStageNumber: Integer;
    function GetCurrentNewDocumentWorkCycleStageName: String;
    function GetAssignedNewDocumentNumber: String;

    function GetNewDocumentUsageEmployeeAccessRightsInfoDTO:
      IDocumentUsageEmployeeAccessRightsInfoDTO;

    function GetDocumentAuthorDto: TDocumentFlowEmployeeInfoDTO;

    property NewDocumentId: Variant read GetNewDocumentId;

    property CurrentNewDocumentWorkCycleStageNumber: Integer
    read GetCurrentNewDocumentWorkCycleStageNumber;

    property CurrentNewDocumentWorkCycleStageName: String
    read GetCurrentNewDocumentWorkCycleStageName;

    property AssignedNewDocumentNumber: String
    read GetAssignedNewDocumentNumber;

    property DocumentAuthorDto: TDocumentFlowEmployeeInfoDTO
    read GetDocumentAuthorDto;

    property NewDocumentUsageEmployeeAccessRightsInfoDTO:
      IDocumentUsageEmployeeAccessRightsInfoDTO
    read GetNewDocumentUsageEmployeeAccessRightsInfoDTO;

  end;

  TAddNewDocumentFullInfoCommandResult =
    class (TInterfacedObject, IAddNewDocumentFullInfoCommandResult)

      private

        FNewDocumentId: Variant;
        FCurrentNewDocumentWorkCycleStageNumber: Integer;
        FCurrentNewDocumentWorkCycleStageName: String;
        FAssignedNewDocumentNumber: String;

        FDocumentAuthorDto: TDocumentFlowEmployeeInfoDTO;
        
        FNewDocumentUsageEmployeeAccessRightsInfoDTO:
          IDocumentUsageEmployeeAccessRightsInfoDTO;

      public

        destructor Destroy; override;

        function GetNewDocumentId: Variant;
        function GetCurrentNewDocumentWorkCycleStageNumber: Integer;
        function GetCurrentNewDocumentWorkCycleStageName: String;
        function GetAssignedNewDocumentNumber: String;

        function GetDocumentAuthorDto: TDocumentFlowEmployeeInfoDTO;

        function GetNewDocumentUsageEmployeeAccessRightsInfoDTO:
          IDocumentUsageEmployeeAccessRightsInfoDTO;


        procedure SetNewDocumentId(Value: Variant);
        procedure SetCurrentNewDocumentWorkCycleStageNumber(Value: Integer);
        procedure SetCurrentNewDocumentWorkCycleStageName(Value: String);
        procedure SetAssignedNewDocumentNumber(Value: String);
        procedure SetDocumentAuthorDto(Value: TDocumentFlowEmployeeInfoDTO);

        procedure SetNewDocumentUsageEmployeeAccessRightsInfoDTO(
          const Value: IDocumentUsageEmployeeAccessRightsInfoDTO
        );

        property NewDocumentId: Variant
        read GetNewDocumentId write SetNewDocumentId;
        
        property CurrentNewDocumentWorkCycleStageNumber: Integer
        read GetCurrentNewDocumentWorkCycleStageNumber
        write SetCurrentNewDocumentWorkCycleStageNumber;

        property CurrentNewDocumentWorkCycleStageName: String
        read GetCurrentNewDocumentWorkCycleStageName
        write SetCurrentNewDocumentWorkCycleStageName;

        property AssignedNewDocumentNumber: String
        read GetAssignedNewDocumentNumber
        write SetAssignedNewDocumentNumber;

        property DocumentAuthorDto: TDocumentFlowEmployeeInfoDTO
        read GetDocumentAuthorDto write SetDocumentAuthorDto;

        property NewDocumentUsageEmployeeAccessRightsInfoDTO:
          IDocumentUsageEmployeeAccessRightsInfoDTO
        read GetNewDocumentUsageEmployeeAccessRightsInfoDTO
        write SetNewDocumentUsageEmployeeAccessRightsInfoDTO;

    end;

  TChangeDocumentInfoCommand = class (
                                  TDocumentStorageServiceCommand,
                                  IDocumentStorageServiceCommand
                               )

    private

      FChangingDocumentInfoEmployeeId: Variant;
      FChangedDocumentInfoDTO: TChangedDocumentInfoDTO;

    public

      destructor Destroy; override;
      constructor Create(
        const ChangingDocumentInfoEmployeeId: Variant;
        ChangedDocumentInfoDTO: TChangedDocumentInfoDTO
      );

    published

      property ChangingDocumentInfoEmployeeId: Variant
      read FChangingDocumentInfoEmployeeId;

      property ChangedDocumentInfoDTO: TChangedDocumentInfoDTO
      read FChangedDocumentInfoDTO;

  end;

  TChangeDocumentApprovingsInfoCommand =
    class (TDocumentStorageServiceCommand, IDocumentStorageServiceCommand)

      private

        FChangingEmployeeId: Variant;
        FDocumentId: Variant;
        FChangedDocumentApprovingsInfoDTO: TDocumentApprovingsInfoDTO;

      public

        destructor Destroy; override;

        constructor Create(
          const ChangingEmployeeId: Variant;
          const DocumentId: Variant;
          ChangedDocumentApprovingsInfoDTO: TDocumentApprovingsInfoDTO
        );

      published

        property ChangingEmployeeId: Variant
        read FChangingEmployeeId write FChangingEmployeeId;

        property DocumentId: Variant
        read FDocumentId write FDocumentId;
        
        property ChangedDocumentApprovingsInfoDTO:
          TDocumentApprovingsInfoDTO
        read FChangedDocumentApprovingsInfoDTO
        write FChangedDocumentApprovingsInfoDTO;

    end;

  TRemoveDocumentsInfoCommand =
    class (TDocumentStorageServiceCommand, IDocumentStorageServiceCommand)

      private

        FRemovingDocumentsInfoEmployeeId: Variant;
        FRemovableDocumentIds: TVariantList;

      public

        destructor Destroy; override;
        constructor Create(
          RemovingDocumentsInfoEmployeeId: Variant;
          RemovableDocumentIds: TVariantList
        );

      published

        property RemovingDocumentsInfoEmployeeId: Variant
        read FRemovingDocumentsInfoEmployeeId;

        property RemovableDocumentIds: TVariantList
        read FRemovableDocumentIds;

    end;
  
implementation

{ TAddNewDocumentFullInfoCommand }

constructor TAddNewDocumentFullInfoCommand.Create(
  const CreatingNewDocumentEmployeeId: Variant;
  NewDocumentInfoDTO: TNewDocumentInfoDTO
);
begin

  inherited Create;

  FCreatingNewDocumentEmployeeId := CreatingNewDocumentEmployeeId;
  FNewDocumentInfoDTO := NewDocumentInfoDTO;

end;

destructor TAddNewDocumentFullInfoCommand.Destroy;
begin

  FreeAndNil(FNewDocumentInfoDTO);
  inherited;

end;

{ TChangeDocumentInfoCommand }

constructor TChangeDocumentInfoCommand.Create(
  const ChangingDocumentInfoEmployeeId: Variant;
  ChangedDocumentInfoDTO: TChangedDocumentInfoDTO);
begin

  inherited Create;

  FChangingDocumentInfoEmployeeId := ChangingDocumentInfoEmployeeId;
  FChangedDocumentInfoDTO := ChangedDocumentInfoDTO;

end;

destructor TChangeDocumentInfoCommand.Destroy;
begin

  FreeAndNil(FChangedDocumentInfoDTO);
  inherited;

end;

{ TRemoveDocumentsInfoCommand }

constructor TRemoveDocumentsInfoCommand.Create(
  RemovingDocumentsInfoEmployeeId: Variant;
  RemovableDocumentIds: TVariantList
);
begin

  inherited Create;

  FRemovingDocumentsInfoEmployeeId := RemovingDocumentsInfoEmployeeId;
  FRemovableDocumentIds := RemovableDocumentIds;
  
end;

destructor TRemoveDocumentsInfoCommand.Destroy;
begin

  FreeAndNil(FRemovableDocumentIds);
  inherited;

end;

{ TGettingDocumentFullInfoCommand }

constructor TGettingDocumentFullInfoCommand.Create(
  DocumentId,
  RequestingEmployeeId: Variant
);
begin

  inherited Create;

  FDocumentId := DocumentId;
  FRequestingEmployeeId := RequestingEmployeeId;

end;

{ TGettingDocumentFullInfoCommandResult }

constructor TGettingDocumentFullInfoCommandResult.Create(
  DocumentFullInfoDTO: TDocumentFullInfoDTO;
  DocumentUsageEmployeeAccessRightsInfoDTO: IDocumentUsageEmployeeAccessRightsInfoDTO);
begin

  inherited Create;

  FDocumentFullInfoDTO := DocumentFullInfoDTO;
  FDocumentUsageEmployeeAccessRightsInfoDTO := DocumentUsageEmployeeAccessRightsInfoDTO;
  
end;

destructor TGettingDocumentFullInfoCommandResult.Destroy;
begin

  FreeAndNil(FDocumentFullInfoDTO);
  
  inherited;

end;

function TGettingDocumentFullInfoCommandResult.GetDocumentFullInfoDTO: TDocumentFullInfoDTO;
begin

  Result := FDocumentFullInfoDTO;
  
end;

function TGettingDocumentFullInfoCommandResult.GetDocumentUsageEmployeeAccessRightsInfoDTO: IDocumentUsageEmployeeAccessRightsInfoDTO;
begin

  Result := FDocumentUsageEmployeeAccessRightsInfoDTO;

end;

{ TAddNewDocumentFullInfoCommandResult }

destructor TAddNewDocumentFullInfoCommandResult.Destroy;
begin

  FreeAndNil(FDocumentAuthorDto);

  inherited;

end;

function TAddNewDocumentFullInfoCommandResult.GetAssignedNewDocumentNumber: String;
begin

  Result := FAssignedNewDocumentNumber;
  
end;

function TAddNewDocumentFullInfoCommandResult.GetCurrentNewDocumentWorkCycleStageName: String;
begin

  Result := FCurrentNewDocumentWorkCycleStageName;
  
end;

function TAddNewDocumentFullInfoCommandResult.GetCurrentNewDocumentWorkCycleStageNumber: Integer;
begin

  Result := FCurrentNewDocumentWorkCycleStageNumber;
  
end;

function TAddNewDocumentFullInfoCommandResult.GetDocumentAuthorDto: TDocumentFlowEmployeeInfoDTO;
begin

  Result := FDocumentAuthorDto;
  
end;

function TAddNewDocumentFullInfoCommandResult.GetNewDocumentId: Variant;
begin

  Result := FNewDocumentId;
  
end;

function TAddNewDocumentFullInfoCommandResult.
  GetNewDocumentUsageEmployeeAccessRightsInfoDTO:
    IDocumentUsageEmployeeAccessRightsInfoDTO;
begin

  Result := FNewDocumentUsageEmployeeAccessRightsInfoDTO;
  
end;

procedure TAddNewDocumentFullInfoCommandResult.SetAssignedNewDocumentNumber(
  Value: String);
begin

  FAssignedNewDocumentNumber := Value;
  
end;

procedure TAddNewDocumentFullInfoCommandResult.SetCurrentNewDocumentWorkCycleStageName(
  Value: String);
begin

  FCurrentNewDocumentWorkCycleStageName := Value;

end;

procedure TAddNewDocumentFullInfoCommandResult.SetCurrentNewDocumentWorkCycleStageNumber(
  Value: Integer);
begin

  FCurrentNewDocumentWorkCycleStageNumber := Value;
  
end;

procedure TAddNewDocumentFullInfoCommandResult.SetDocumentAuthorDto(
  Value: TDocumentFlowEmployeeInfoDTO);
begin

  FreeAndNil(FDocumentAuthorDto);

  FDocumentAuthorDto := Value;
  
end;

procedure TAddNewDocumentFullInfoCommandResult.SetNewDocumentId(Value: Variant);
begin

  FNewDocumentId := Value;
  
end;

procedure TAddNewDocumentFullInfoCommandResult.
  SetNewDocumentUsageEmployeeAccessRightsInfoDTO(
    const Value: IDocumentUsageEmployeeAccessRightsInfoDTO
  );
begin

  FNewDocumentUsageEmployeeAccessRightsInfoDTO := Value;
  
end;

{ TChangeDocumentApprovingsInfoCommand }

constructor TChangeDocumentApprovingsInfoCommand.Create(
  const ChangingEmployeeId: Variant;
  const DocumentId: Variant;
  ChangedDocumentApprovingsInfoDTO: TDocumentApprovingsInfoDTO
);
begin

  inherited Create;

  FChangingEmployeeId := ChangingEmployeeId;
  FDocumentId := DocumentId;
  FChangedDocumentApprovingsInfoDTO := ChangedDocumentApprovingsInfoDTO;
  
end;

destructor TChangeDocumentApprovingsInfoCommand.Destroy;
begin

  FreeAndNil(FChangedDocumentApprovingsInfoDTO);
  
  inherited;

end;

{ TDocumentCreatingCommand }

constructor TDocumentCreatingCommand.Create(const EmployeeId: Variant);
begin

  inherited Create;

  Self.EmployeeId := EmployeeId;
  
end;

function TDocumentCreatingCommand.GetEmployeeId: Variant;
begin

  Result := FEmployeeId;

end;

procedure TDocumentCreatingCommand.SetEmployeeId(const Value: Variant);
begin

  FEmployeeId := Value;

end;

{ TDocumentCreatingCommandResult }

constructor TDocumentCreatingCommandResult.Create(
  DocumentFullInfoDTO: TDocumentFullInfoDTO;
  DocumentAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO);
begin

  inherited Create;

  Self.DocumentFullInfoDTO := DocumentFullInfoDTO;
  Self.DocumentAccessRightsInfoDTO := DocumentAccessRightsInfoDTO;

end;

function TDocumentCreatingCommandResult.GetDocumentAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO;
begin

  Result := FDocumentAccessRightsInfoDTO;

end;

function TDocumentCreatingCommandResult.GetDocumentFullInfoDTO: TDocumentFullInfoDTO;
begin

  Result := FDocumentFullInfoDTO;

end;

procedure TDocumentCreatingCommandResult.SetDocumentAccessRightsInfoDTO(
  const Value: TDocumentUsageEmployeeAccessRightsInfoDTO);
begin

  FDocumentAccessRightsInfoDTO := Value;
  FFreeDocumentAccessRightsInfoDTO := Value;

end;

procedure TDocumentCreatingCommandResult.SetDocumentFullInfoDTO(
  const Value: TDocumentFullInfoDTO);
begin

  FDocumentFullInfoDTO := Value;
  FFreeDocumentFullInfoDTO := Value;
  
end;

end.
