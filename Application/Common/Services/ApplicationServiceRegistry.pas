unit ApplicationServiceRegistry;

interface

uses

  ApplicationService,
  SysUtils,
  Classes,
  IGetSelfUnit;

type

  IApplicationServiceRegistryKey = interface (IGetSelf)

    function Equals(Other: IApplicationServiceRegistryKey): Boolean;

  end;

  TApplicationServiceRegistryKey = class abstract (TInterfacedObject, IApplicationServiceRegistryKey)

    public

      function GetSelf: TObject;

      function Equals(Other: IApplicationServiceRegistryKey): Boolean; virtual; abstract;

  end;

  TApplicationServiceRegistryObjectKey = class (TApplicationServiceRegistryKey)

    protected

      FInnerObject: TObject;
      
    public

      destructor Destroy; override;
      constructor Create(InnerObject: TObject);
      
      function Equals(Other: IApplicationServiceRegistryKey): Boolean; override;

  end;

  TApplicationServiceRegistryVariantKey = class (TApplicationServiceRegistryKey)

    protected

      FInnerVariant: Variant;

    public

      constructor Create(InnerVariant: Variant);
      
      function Equals(Other: IApplicationServiceRegistryKey): Boolean; override;

  end;

  TApplicationServiceRegistryClassKey = class (TApplicationServiceRegistryKey)

    protected

      FInnerClass: TClass;

    public

      constructor Create(InnerClass: TClass);
      
      function Equals(Other: IApplicationServiceRegistryKey): Boolean; override;

  end;

  TInheritanceClassCheckingKey =
    class (TApplicationServiceRegistryClassKey)

      function Equals(Other: IApplicationServiceRegistryKey): Boolean; override;
      
    end;

  TParentClassEqualityCheckingKey =
    class (TApplicationServiceRegistryClassKey)

      function Equals(Other: IApplicationServiceRegistryKey): Boolean; override;
      
    end;

  
  TApplicationServiceRegistryKeys = class

    public

      class function KeyFor(ClassObject: TClass): TApplicationServiceRegistryClassKey; overload; static;
      class function KeyFor(ObjectRef: TObject): TApplicationServiceRegistryObjectKey; overload; static;
      class function KeyFor(VariantObject: Variant): TApplicationServiceRegistryVariantKey; overload; static;
      
  end;

  TApplicationServiceRegistry = class 

    private

    protected

      type

        TApplicationServiceRegistryEntry = class

          Key: IApplicationServiceRegistryKey;
          Service: IApplicationService;

          constructor Create(
            Key: IApplicationServiceRegistryKey;
            Service: IApplicationService
          );

        end;

    protected

      FServiceList: TList;

      function FindApplicationServiceEntryByKey(
        Key: IApplicationServiceRegistryKey
      ): TApplicationServiceRegistryEntry; overload;

      procedure AddApplicationServiceEntryFrom(
        Key: IApplicationServiceRegistryKey;
        Service: IApplicationService
      ); overload;

      function FindApplicationServiceEntryByKey(
        ServiceList: TList;
        Key: IApplicationServiceRegistryKey
      ): TApplicationServiceRegistryEntry; overload; virtual;

      procedure AddApplicationServiceEntryFrom(
        ServiceList: TList;
        Key: IApplicationServiceRegistryKey;
        Service: IApplicationService
      ); overload;

    public

      procedure RegisterApplicationService(
        Key: IApplicationServiceRegistryKey;
        Service: IApplicationService
      );

      function GetApplicationService(
        Key: IApplicationServiceRegistryKey
      ): IApplicationService;

      function GetApplicationServiceByClass(
        AClass: TClass
      ): IApplicationService;

      function GetApplicationServiceByClassOrNearestAncestorClass(
        AClass: TClass
      ): IApplicationService;

      function GetApplicationServiceByNearestAncestorClass(
        DescendantClass: TClass
      ): IApplicationService;

    public
    
      destructor Destroy; override;
      constructor Create; virtual;
      
  end;
  
implementation

uses

  AuxCollectionFunctionsUnit;
  
{ TApplicationServiceRegistry }

procedure TApplicationServiceRegistry.AddApplicationServiceEntryFrom(
  Key: IApplicationServiceRegistryKey;
  Service: IApplicationService
);
begin

  AddApplicationServiceEntryFrom(FServiceList, Key, Service);
  
end;

procedure TApplicationServiceRegistry.AddApplicationServiceEntryFrom(
  ServiceList: TList;
  Key: IApplicationServiceRegistryKey;
  Service: IApplicationService
);
begin

  ServiceList.Add(
    TApplicationServiceRegistryEntry.Create(
      Key, Service
    )
  );
  
end;

constructor TApplicationServiceRegistry.Create;
begin

  inherited;

  FServiceList := TList.Create;
  
end;

destructor TApplicationServiceRegistry.Destroy;
begin

  FreeListWithItems(FServiceList);
  inherited;

end;

function TApplicationServiceRegistry.FindApplicationServiceEntryByKey(
  ServiceList: TList;
  Key: IApplicationServiceRegistryKey
): TApplicationServiceRegistryEntry;
var I: Integer;
    Entry: TApplicationServiceRegistryEntry;
begin

  for I := 0 to ServiceList.Count - 1 do begin

    Entry := TApplicationServiceRegistryEntry(FServiceList[I]);

    if Entry.Key.Equals(Key) then begin

      Result := Entry;
      Exit;
      
    end;
    
  end;

  Result := nil;
  
end;

function TApplicationServiceRegistry.FindApplicationServiceEntryByKey(
  Key: IApplicationServiceRegistryKey): TApplicationServiceRegistryEntry;
begin

  Result := FindApplicationServiceEntryByKey(FServiceList, Key);

end;

function TApplicationServiceRegistry.GetApplicationService(
  Key: IApplicationServiceRegistryKey): IApplicationService;
var Entry: TApplicationServiceRegistryEntry;
begin

  Entry := FindApplicationServiceEntryByKey(Key);

  if Assigned(Entry) then
    Result := Entry.Service

  else Result := nil;
  
end;

function TApplicationServiceRegistry.GetApplicationServiceByClass(
  AClass: TClass): IApplicationService;
begin

  Result :=
    GetApplicationService(
      TApplicationServiceRegistryKeys.KeyFor(
        AClass
      )
    );
    
end;

function TApplicationServiceRegistry.
  GetApplicationServiceByClassOrNearestAncestorClass(
    AClass: TClass
  ): IApplicationService;
begin

  Result := GetApplicationServiceByClass(AClass);

  if not Assigned(Result) then
    Result := GetApplicationServiceByNearestAncestorClass(AClass);
    
end;

function TApplicationServiceRegistry.
  GetApplicationServiceByNearestAncestorClass(
    DescendantClass: TClass
  ): IApplicationService;
var DescendantServiceClass: TClass;
begin

  Result := nil;

  while not Assigned(Result) and Assigned(DescendantClass)
  do begin

    Result :=
      GetApplicationService(
        TParentClassEqualityCheckingKey.Create(DescendantClass)
      );

    DescendantClass := DescendantClass.ClassParent;
    
  end;

end;

procedure TApplicationServiceRegistry.RegisterApplicationService(
  Key: IApplicationServiceRegistryKey;
  Service: IApplicationService
);
var Entry: TApplicationServiceRegistryEntry;
begin

  Entry := FindApplicationServiceEntryByKey(Key);

  if Assigned(Entry) then
    Entry.Service := Service

  else AddApplicationServiceEntryFrom(Key, Service);

end;

{ TApplicationServiceRegistry.TApplicationServiceRegistryEntry }

constructor TApplicationServiceRegistry.TApplicationServiceRegistryEntry.Create(
  Key: IApplicationServiceRegistryKey; Service: IApplicationService);
begin

  inherited Create;

  Self.Key := Key;
  Self.Service := Service;
  
end;

{ TApplicationServiceRegistryObjectKey }

constructor TApplicationServiceRegistryObjectKey.Create(InnerObject: TObject);
begin

  inherited Create;

  FInnerObject := InnerObject;
  
end;

destructor TApplicationServiceRegistryObjectKey.Destroy;
begin

  FreeAndNil(FInnerObject);
  inherited;

end;

function TApplicationServiceRegistryObjectKey.Equals(
  Other: IApplicationServiceRegistryKey): Boolean;
begin

  Result :=
    FInnerObject =
      (Other.Self as TApplicationServiceRegistryObjectKey).FInnerObject;

end;

{ TApplicationServiceRegistryVariantKey }

constructor TApplicationServiceRegistryVariantKey.Create(InnerVariant: Variant);
begin

  inherited Create;

  FInnerVariant := InnerVariant;
  
end;

function TApplicationServiceRegistryVariantKey.Equals(
  Other: IApplicationServiceRegistryKey): Boolean;
begin

  Result :=
    FInnerVariant =
      (Other.Self as TApplicationServiceRegistryVariantKey).FInnerVariant;

end;

{ TApplicationServiceRegistryClassKey }

constructor TApplicationServiceRegistryClassKey.Create(InnerClass: TClass);
begin

  inherited Create;

  FInnerClass := InnerClass;
  
end;

function TApplicationServiceRegistryClassKey.Equals(
  Other: IApplicationServiceRegistryKey): Boolean;
begin

  Result :=
    FInnerClass =
      (Other.Self as TApplicationServiceRegistryClassKey).FInnerClass;
    
end;

{ TApplicationServiceRegistryKey }

function TApplicationServiceRegistryKey.GetSelf: TObject;
begin

  Result := Self;
  
end;

{ TApplicationServiceRegistryKeys }

class function TApplicationServiceRegistryKeys.KeyFor(
  ClassObject: TClass): TApplicationServiceRegistryClassKey;
begin

  Result := TApplicationServiceRegistryClassKey.Create(ClassObject);
  
end;

class function TApplicationServiceRegistryKeys.KeyFor(
  ObjectRef: TObject): TApplicationServiceRegistryObjectKey;
begin

  Result := TApplicationServiceRegistryObjectKey.Create(ObjectRef);
  
end;

class function TApplicationServiceRegistryKeys.KeyFor(
  VariantObject: Variant): TApplicationServiceRegistryVariantKey;
begin

  Result := TApplicationServiceRegistryVariantKey.Create(VariantObject);
  
end;

{ TInheritanceClassCheckingKey }

function TInheritanceClassCheckingKey.Equals(
  Other: IApplicationServiceRegistryKey
): Boolean;
var OtherKey: TInheritanceClassCheckingKey;
begin

  OtherKey := Other.Self as TInheritanceClassCheckingKey;

  Result := OtherKey.InheritsFrom(FInnerClass);
  
end;

{ TParentClassEqualityCheckingKey }

function TParentClassEqualityCheckingKey.Equals(
  Other: IApplicationServiceRegistryKey): Boolean;
var OtherKey: TParentClassEqualityCheckingKey;
begin

  OtherKey := Other.Self as TParentClassEqualityCheckingKey;

  Result := OtherKey.ClassParent = FInnerClass;
  
end;

end.
