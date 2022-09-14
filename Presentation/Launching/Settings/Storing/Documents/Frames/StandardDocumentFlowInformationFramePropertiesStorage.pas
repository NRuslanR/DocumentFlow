unit StandardDocumentFlowInformationFramePropertiesStorage;

interface

uses

  unDocumentFlowInformationFrame,
  UserInterfaceSwitch,
  IPropertiesStorageUnit,
  DocumentFlowInformationFramePropertiesStorage,
  StandardDefaultObjectPropertiesStorage,
  SysUtils;

type

  TStandardDocumentFlowInformationFramePropertiesStorage =
    class (
      TStandardDefaultObjectPropertiesStorage,
      IDocumentFlowInformationFramePropertiesStorage
    )

      protected

        procedure InternalRestoreFramePropertiesForUserInterfaceKind(
          Frame: TDocumentFlowInformationFrame;
          UserInterfaceKind: TUserInterfaceKind;
          PropertiesStorage: IPropertiesStorage
        ); virtual;

        procedure InternalSaveFramePropertiesForUserInterfaceKind(
          Frame: TDocumentFlowInformationFrame;
          UserInterfaceKind: TUserInterfaceKind;
          PropertiesStorage: IPropertiesStorage
        ); virtual;

      public

        procedure RestoreFramePropertiesForUserInterfaceKind(
          Frame: TDocumentFlowInformationFrame;
          UserInterfaceKind: TUserInterfaceKind
        );

        procedure SaveFramePropertiesForUserInterfaceKind(
          Frame: TDocumentFlowInformationFrame;
          UserInterfaceKind: TUserInterfaceKind
        );

    end;

implementation

{ TStandardDocumentFlowInformationFramePropertiesStorage }

procedure TStandardDocumentFlowInformationFramePropertiesStorage.
  RestoreFramePropertiesForUserInterfaceKind(
    Frame: TDocumentFlowInformationFrame;
    UserInterfaceKind: TUserInterfaceKind
  );
begin

  InternalRestoreFramePropertiesForUserInterfaceKind(
    Frame, UserInterfaceKind, FPropertiesStorage
  );

end;

procedure TStandardDocumentFlowInformationFramePropertiesStorage.
  SaveFramePropertiesForUserInterfaceKind(
    Frame: TDocumentFlowInformationFrame;
    UserInterfaceKind: TUserInterfaceKind
  );
begin

  InternalSaveFramePropertiesForUserInterfaceKind(
    Frame, UserInterfaceKind, FPropertiesStorage
  );

end;

procedure TStandardDocumentFlowInformationFramePropertiesStorage.InternalRestoreFramePropertiesForUserInterfaceKind(
  Frame: TDocumentFlowInformationFrame;
  UserInterfaceKind: TUserInterfaceKind;
  PropertiesStorage: IPropertiesStorage
);
begin

end;

procedure TStandardDocumentFlowInformationFramePropertiesStorage.InternalSaveFramePropertiesForUserInterfaceKind(
  Frame: TDocumentFlowInformationFrame;
  UserInterfaceKind: TUserInterfaceKind;
  PropertiesStorage: IPropertiesStorage
);
begin

end;

end.
