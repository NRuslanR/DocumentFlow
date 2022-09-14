unit StandardApplicationSettingsResetService;

interface

uses

  SysUtils,
  Classes,
  ObjectClasses,
  IObjectPropertiesStorageRegistryUnit,
  IObjectPropertiesStorageUnit,
  IPropertiesStorageUnit,
  ArrayTypes,
  ApplicationSettingsResetService;

type

  TStandardApplicationSettingsResetService =
    class (TInterfacedObject, IApplicatonSettingsResetService)

      private

        FObjectPropertiesStorageRegistry: IObjectPropertiesStorageRegistry;
        
      public

        constructor Create(ObjectPropertiesStorageRegistry: IObjectPropertiesStorageRegistry);

        procedure ResetApplicationSettings;
        
    end;
    
implementation

uses

  Forms,
  VariantListUnit,
  ArrayFunctions,
  Controls,
  TypInfo,
  VariantFunctions,
  Variants,
  AuxDebugFunctionsUnit,
  StandardObjectPropertiesStorage,
  DBDataTableFormPropertiesStorage,
  ReflectionServicesUnit;

{ TStandardApplicationSettingsResetService }

constructor TStandardApplicationSettingsResetService.Create(
  ObjectPropertiesStorageRegistry: IObjectPropertiesStorageRegistry);
begin

  inherited Create;

  FObjectPropertiesStorageRegistry := ObjectPropertiesStorageRegistry;

end;

procedure TStandardApplicationSettingsResetService.ResetApplicationSettings;

  procedure RemovePropertiesExcept(
    PropertiesStorage: IPropertiesStorage;
    ExceptPropertyNames: array of Variant
  );

      procedure RemoveSectionPropertiesExcept(
        const SectionId: Variant;
        PropertyNames: TStrings
      );
      var
          I: Integer;
          PropertyName: String;
      begin

        for I := 0 to PropertyNames.Count - 1 do begin

          PropertyName := PropertyNames.Names[I];

          if not AreValuesIncludedByArray([PropertyName], ExceptPropertyNames)
          then PropertiesStorage.RemoveProperty(SectionId, PropertyName);

        end;

      end;

  var
      SectionIds: TVariantList;
      SectionId: Variant;
      PropertyNames: TStrings;
  begin

    SectionIds := PropertiesStorage.GetSectionIds;

    try

      for SectionId in SectionIds do begin

        PropertyNames := PropertiesStorage.GetPropertyNames(SectionId);

        try

          RemoveSectionPropertiesExcept(SectionId, PropertyNames);
            
        finally

          FreeAndNil(PropertyNames);

        end

      end;

    finally

      FreeAndNil(SectionIds);

    end

  end;

  function ClearAllPropertiesStorageExcept(
    ObjectPropertiesStorage: IObjectPropertiesStorage;
    ExceptPropertyNames: array of Variant
  ): Boolean;
  var
      PropertiesStorageVariant: Variant;
      PropertiesStorage: IPropertiesStorage;
  begin

    PropertiesStorageVariant :=
      TReflectionServices.GetObjectPropertyValue(
        ObjectPropertiesStorage.Self,
        'PropertiesStorage'
      );

    if VarIsNullOrEmpty(PropertiesStorageVariant) then begin

      Result := False;
      Exit;
      
    end;                                                

    PropertiesStorage :=
      IPropertiesStorage(TVarData(PropertiesStorageVariant).VPointer);

    RemovePropertiesExcept(PropertiesStorage, ExceptPropertyNames);

    Result := True;
    
  end;

var
    ObjectClasses: TClasses;
    ObjectClass: TClass;
    ObjectPropertiesStorage: IObjectPropertiesStorage;
    ObjectPropertiesStorageVariant: Variant;
begin

  ObjectClasses := FObjectPropertiesStorageRegistry.GetObjectClasses;

  try

    for ObjectClass in ObjectClasses do begin

      if not ObjectClass.InheritsFrom(TWinControl) then Continue;

      ObjectPropertiesStorage :=
        FObjectPropertiesStorageRegistry
          .GetPropertiesStorageForObjectClass(ObjectClass);

      if
        not
        ClearAllPropertiesStorageExcept(
          ObjectPropertiesStorage,
          ['UserInterfaceKind']
        )
      then Continue;
                                                                
      if not (ObjectPropertiesStorage.Self is TDBDataTableFormPropertiesStorage)
      then Continue;

      ObjectPropertiesStorageVariant :=
        TReflectionServices.GetObjectPropertyValue(
          ObjectPropertiesStorage.Self,
          'FilterFormStatePropertiesStorage'
        );

      if VarIsNull(ObjectPropertiesStorageVariant) then Continue;

      Supports(
        TObject(TVarData(ObjectPropertiesStorageVariant).VPointer),
        IObjectPropertiesStorage,
        ObjectPropertiesStorage
      );

      if Assigned(ObjectPropertiesStorage) then begin

        ClearAllPropertiesStorageExcept(
          ObjectPropertiesStorage,
          ['UserInterfaceKind']
        );

      end;

    end;

  finally

    FreeAndNil(ObjectClasses);
    
  end;

end;

end.
