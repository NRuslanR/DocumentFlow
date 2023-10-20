unit LoodsmanDocumentsUploadingAccessRights;

interface

uses

  IGetSelfUnit,
  SysUtils,
  Classes;

type

  ILoodsmanDocumentsUploadingAccessRights = interface (IGetSelf)


  end;

  TLoodsmanDocumentsUploadingAccessRights =
    class (TInterfacedObject, ILoodsmanDocumentsUploadingAccessRights)

      public

        UploadingAccessible: Boolean;

      public

        function GetSelf: TObject;

        function AllAccessRightsAbsent: Boolean;
        
    end;

implementation

{ TLoodsmanDocumentsUploadingAccessRights }

function TLoodsmanDocumentsUploadingAccessRights.AllAccessRightsAbsent: Boolean;
begin

  Result :=
    not (
      UploadingAccessible
    );
    
end;

function TLoodsmanDocumentsUploadingAccessRights.GetSelf: TObject;
begin

  Result := Self;
  
end;

end.
