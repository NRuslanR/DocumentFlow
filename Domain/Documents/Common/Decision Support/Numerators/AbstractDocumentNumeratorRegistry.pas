unit AbstractDocumentNumeratorRegistry;

interface

uses

  INumberGeneratorUnit,
  DocumentNumerator,
  StandardDocumentNumerator,
  DocumentNumeratorRegistry,
  SysUtils,
  Document,
  Department,
  Classes;

type

  TDocumentNumeratorRegistry = class;
  TDocumentNumeratorRegistryClass = class of TDocumentNumeratorRegistry;

  TDocumentNumeratorRegistry =
    class abstract (TInterfacedObject, IDocumentNumeratorRegistry)

      protected

        type

          TDocumentNumeratorRegistryEntry = class

            DepartmentId: Variant;
            DocumentType: TDocumentClass;
            DocumentNumerator: TDocumentNumerator;
            FreeDocumentNumerator: IDocumentNumerator;

            constructor Create(
              DocumentType: TDocumentClass;
              DepartmentId: Variant;
              DocumentNumerator: TDocumentNumerator
            );

          end;

      protected

        FEntries: TList;

        class var FInstance: IDocumentNumeratorRegistry;

      protected

        function GetNumberConstantPartsBy(
          DocumentType: TDocumentClass;
          const DepartmentId: Variant
        ): TDocumentNumberConstantParts; virtual; abstract;
        
        function CreateNumberGeneratorBy(
          DocumentType: TDocumentClass;
          const DepartmentId: Variant
        ): INumberGenerator; virtual; abstract;

        function FindDocumentNumeratorBy(
          DocumentType: TDocumentClass;
          const DepartmentId: Variant
        ): TDocumentNumerator;

        procedure AddNewDocumentNumeratorEntryFor(
          DocumentType: TDocumentClass;
          const DepartmentId: Variant;
          DocumentNumerator: TDocumentNumerator
        );

        class function GetInstance: IDocumentNumeratorRegistry; static;
        class procedure SetInstance(
          DocumentNumeratorRegistry: IDocumentNumeratorRegistry
        ); static;

      public

        destructor Destroy; override;
        constructor Create;

        function GetDocumentNumeratorFor(
          DocumentType: TDocumentClass;
          const DepartmentId: Variant
        ): TDocumentNumerator;

        class property Current: IDocumentNumeratorRegistry
        read GetInstance write SetInstance;

  end;

implementation

uses

  AuxCollectionFunctionsUnit;

{ TDocumentNumeratorRegistry }

procedure TDocumentNumeratorRegistry.AddNewDocumentNumeratorEntryFor(
  DocumentType: TDocumentClass;
  const DepartmentId: Variant;
  DocumentNumerator: TDocumentNumerator);
begin

  FEntries.Add(
    TDocumentNumeratorRegistryEntry.Create(
      DocumentType,
      DepartmentId,
      DocumentNumerator
    )
  );
  
end;

constructor TDocumentNumeratorRegistry.Create;
begin

  inherited;

  FEntries := TList.Create;
  
end;

destructor TDocumentNumeratorRegistry.Destroy;
begin

  FreeListItems(FEntries);
  inherited;
  
end;

function TDocumentNumeratorRegistry.
  FindDocumentNumeratorBy(
    DocumentType: TDocumentClass;
    const DepartmentId: Variant
  ): TDocumentNumerator;
var Entry: TDocumentNumeratorRegistryEntry;
    I: Integer;
begin

  for I := 0 to FEntries.Count - 1 do begin

    Entry := TDocumentNumeratorRegistryEntry(FEntries[I]);

    if (Entry.DepartmentId = DepartmentId) and (Entry.DocumentType = DocumentType)
    then begin

      Result := Entry.DocumentNumerator;
      Exit;

    end;

  end;

  Result := nil;

end;

function TDocumentNumeratorRegistry.
  GetDocumentNumeratorFor(
    DocumentType: TDocumentClass;
    const DepartmentId: Variant
  ): TDocumentNumerator;
var NumberGenerator: INumberGenerator;
    NumberConstantParts: TDocumentNumberConstantParts;
begin

  Result := FindDocumentNumeratorBy(
              DocumentType, DepartmentId
            );

  if not Assigned(Result) then begin

    NumberConstantParts := GetNumberConstantPartsBy(DocumentType, DepartmentId);
    NumberGenerator := CreateNumberGeneratorBy(DocumentType, DepartmentId);
    
    Result :=
      TDocumentNumerator.Create(
        NumberConstantParts,
        NumberGenerator
      );
      
    AddNewDocumentNumeratorEntryFor(
      DocumentType, DepartmentId, Result
    );

  end;

end;

class function TDocumentNumeratorRegistry.GetInstance: IDocumentNumeratorRegistry;
begin

  Result := FInstance;
  
end;

class procedure TDocumentNumeratorRegistry.SetInstance(
  DocumentNumeratorRegistry: IDocumentNumeratorRegistry);
begin

  FInstance := DocumentNumeratorRegistry;

end;

{ TDocumentNumeratorRegistry.TDocumentNumeratorRegistryEntry }

constructor TDocumentNumeratorRegistry.TDocumentNumeratorRegistryEntry.Create(
  DocumentType: TDocumentClass;
  DepartmentId: Variant;
  DocumentNumerator: TDocumentNumerator
);
begin

  inherited Create;

  Self.DocumentType := DocumentType;
  Self.DepartmentId := DepartmentId;

  Self.DocumentNumerator := DocumentNumerator;
  Self.FreeDocumentNumerator := Self.DocumentNumerator;
  
end;

end.
