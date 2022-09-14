unit RelatedDocumentStorageService;

interface

uses

  ApplicationService,
  DocumentStorageServiceCommandsAndRespones,
  DocumentFullInfoDTO;

type

  IGettingRelatedDocumentFullInfoCommand = interface (IDocumentStorageServiceCommand)

    function GetEmployeeId: Variant;
    procedure SetEmployeeId(const Value: Variant);

    function GetSourceDocumentId: Variant;
    procedure SetSourceDocumentId(const Value: Variant);
    
    function GetRelatedDocumentId: Variant;
    procedure SetRelatedDocumentId(const Value: Variant);

    function GetRelatedDocumentKindId: Variant;
    procedure SetRelatedDocumentKindId(const Value: Variant);

    property EmployeeId: Variant
    read GetEmployeeId write SetEmployeeId;

    property SourceDocumentId: Variant
    read GetSourceDocumentId write SetSourceDocumentId;

    property RelatedDocumentId: Variant
    read GetRelatedDocumentId write SetRelatedDocumentId;

    property RelatedDocumentKindId: Variant
    read GetRelatedDocumentKindId write SetRelatedDocumentKindId;

  end;

  TGettingRelatedDocumentFullInfoCommand =
    class (TInterfacedObject, IGettingRelatedDocumentFullInfoCommand)

      private

        FEmployeeId: Variant;
        FSourceDocumentId: Variant;
        FRelatedDocumentId: Variant;
        FRelatedDocumentKindId: Variant;

      public

        constructor Create(
          const EmployeeId: Variant;
          const SourceDocumentId: Variant;
          const RelatedDocumentId: Variant;
          const RelatedDocumentKindId: Variant
        );

        function GetEmployeeId: Variant;
        procedure SetEmployeeId(const Value: Variant);

        function GetSourceDocumentId: Variant;
        procedure SetSourceDocumentId(const Value: Variant);
    
        function GetRelatedDocumentId: Variant;
        procedure SetRelatedDocumentId(const Value: Variant);

        function GetRelatedDocumentKindId: Variant;
        procedure SetRelatedDocumentKindId(const Value: Variant);

      published

        property EmployeeId: Variant
        read GetEmployeeId write SetEmployeeId;

        property SourceDocumentId: Variant
        read GetSourceDocumentId write SetSourceDocumentId;

        property RelatedDocumentId: Variant
        read GetRelatedDocumentId write SetRelatedDocumentId;

        property RelatedDocumentKindId: Variant
        read GetRelatedDocumentKindId write SetRelatedDocumentKindId;
    
    end;
  
   IRelatedDocumentStorageService = interface (IApplicationService)

      function GetRelatedDocumentFullInfo(
        RelatedDocumentFullInfoCommand: TGettingRelatedDocumentFullInfoCommand
      ): TGettingDocumentFullInfoCommandResult;

    end;

implementation

{ TGettingRelatedDocumentFullInfoCommand }

constructor TGettingRelatedDocumentFullInfoCommand.Create(const EmployeeId,
  SourceDocumentId, RelatedDocumentId, RelatedDocumentKindId: Variant);
begin

  inherited Create;

  Self.EmployeeId := EmployeeId;
  Self.SourceDocumentId := SourceDocumentId;
  Self.RelatedDocumentId := RelatedDocumentId;
  Self.RelatedDocumentKindId := RelatedDocumentKindId;
  
end;

function TGettingRelatedDocumentFullInfoCommand.GetEmployeeId: Variant;
begin

  Result := FEmployeeId;
  
end;

function TGettingRelatedDocumentFullInfoCommand.GetRelatedDocumentId: Variant;
begin

  Result := FRelatedDocumentId;
  
end;

function TGettingRelatedDocumentFullInfoCommand.GetRelatedDocumentKindId: Variant;
begin

  Result := FRelatedDocumentKindId;
  
end;

function TGettingRelatedDocumentFullInfoCommand.GetSourceDocumentId: Variant;
begin

  Result := FSourceDocumentId;
  
end;

procedure TGettingRelatedDocumentFullInfoCommand.SetEmployeeId(
  const Value: Variant);
begin

  FEmployeeId := Value;
  
end;

procedure TGettingRelatedDocumentFullInfoCommand.SetRelatedDocumentId(
  const Value: Variant);
begin

  FRelatedDocumentId := Value;
  
end;

procedure TGettingRelatedDocumentFullInfoCommand.SetRelatedDocumentKindId(
  const Value: Variant);
begin

  FRelatedDocumentKindId := Value;
  
end;

procedure TGettingRelatedDocumentFullInfoCommand.SetSourceDocumentId(
  const Value: Variant);
begin

  FSourceDocumentId := Value;

end;

end.
