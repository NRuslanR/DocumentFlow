unit DocumentInfoHolder;

interface

uses

  DB,
  AbstractDataSetHolder,
  DocumentApprovingsInfoHolder,
  SysUtils,
  Classes;

type

  TDocumentInfoFieldNames = class (TAbstractDataSetFieldDefs)

    public

      IdFieldName: String;
      BaseIdFieldName: String;
      NumberFieldName: String;
      NameFieldName: String;
      FullNameFieldName: String;
      ContentFieldName: String;
      NoteFieldName: String;
      ProductCodeFieldName: String;
      IsSelfRegisteredFieldName: String;
      CreationDateFieldName: String;
      DateFieldName: String;
      KindFieldName: String;
      KindIdFieldName: String;
      CurrentWorkCycleStageNameFieldName: String;
      CurrentWorkCycleStageNumberFieldName: String;

      AuthorIdFieldName: String;
      AuthorLeaderIdFieldName: String;
      AuthorNameFieldName: String;
      AuthorSpecialityFieldName: String;
      AuthorDepartmentIdFieldName: String;
      AuthorDepartmentCodeFieldName: String;
      AuthorDepartmentNameFieldName: String;

      ResponsibleIdFieldName: String;
      ResponsibleNameFieldName: String;
      ResponsibleTelephoneNumberFieldName: String;
      ResponsibleDepartmentIdFieldName: String;
      ResponsibleDepartmentCodeFieldName: String;
      ResponsibleDepartmentNameFieldName: String;

      SigningIdFieldName: String;
      SigningDateFieldName: String;
      SignerIdFieldName: String;
      SignerLeaderIdFieldName: String;
      SignerNameFieldName: String;
      SignerSpecialityFieldName: String;
      SignerDepartmentIdFieldName: String;
      SignerDepartmentCodeFieldName: String;
      SignerDepartmentNameFieldName: String;

      ActualSignerIdFieldName: String;
      ActualSignerLeaderIdFieldName: String;
      ActualSignerNameFieldName: String;
      ActualSignerSpecialityFieldName: String;
      ActualSignerDepartmentIdFieldName: String;
      ActualSignerDepartmentCodeFieldName: String;
      ActualSignerDepartmentNameFieldName: String;

  end;

  TDocumentInfoHolder = class (TAbstractDataSetHolder)

    private

    protected
      
      function GetAuthorDepartmentCodeFieldValue: String;
      function GetAuthorDepartmentIdFieldValue: Variant;
      function GetAuthorDepartmentNameFieldValue: String;
      function GetAuthorIdFieldValue: Variant;

      function GetProductCodeFieldValue: String;
      function GetAuthorNameFieldValue: String;
      function GetContentFieldValue: String;
      function GetNoteFieldValue: String;
      function GetIsSelfRegisteredFieldValue: Variant;
      function GetCreationDateFieldValue: TDateTime;
      function GetDateFieldValue: Variant;
      function GetCurrentWorkCycleStageNameFieldValue: String;
      function GetCurrentWorkCycleStageNumberFieldValue: Integer;
      function GetIdFieldValue: Variant;
      function GetBaseIdFieldValue: Variant;
      function GetKindFieldValue: String;
      function GetNameFieldValue: String;
      function GetFullNameFieldValue: String;
      function GetNumberFieldValue: String;
      function GetResponsibleDepartmentCodeFieldValue: String;
      function GetResponsibleDepartmentIdFieldValue: Variant;
      function GetResponsibleDepartmentNameFieldValue: String;
      function GetResponsibleIdFieldValue: Variant;
      function GetResponsibleNameFieldValue: String;
      function GetResponsibleTelephoneNumberFieldValue: String;
      function GetSignerDepartmentCodeFieldValue: String;
      function GetSignerDepartmentIdFieldValue: Variant;
      function GetSignerDepartmentNameFieldValue: String;
      function GetSignerIdFieldValue: Variant;
      function GetSignerNameFieldValue: String;
      function GetSignerSpecialityFieldValue: String;
      function GetSigningDateFieldValue: Variant;
      function GetSigningIdFieldValue: Variant;
      function GetActualSignerDepartmentCodeFieldValue: String;
      function GetActualSignerDepartmentIdFieldValue: Variant;
      function GetActualSignerDepartmentNameFieldValue: String;
      function GetActualSignerIdFieldValue: Variant;
      function GetActualSignerNameFieldValue: String;
      function GetActualSignerSpecialityFieldValue: String;
      function GetActualSignerLeaderIdFieldValue: Variant;
      function GetAuthorLeaderIdFieldValue: Variant;
      function GetSignerLeaderIdFieldValue: Variant;
      function GetKindIdFieldValue: Variant;
      function GetAuthorSpecialityFieldValue: String;

      function GetFieldNames: TDocumentInfoFieldNames;
      procedure SetFieldNames(const Value: TDocumentInfoFieldNames); virtual;

      class function GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass; override;

    published

      property FieldNames: TDocumentInfoFieldNames
      read GetFieldNames write SetFieldNames;

      property IdFieldValue: Variant
      read GetIdFieldValue;

      property BaseIdFieldValue: Variant
      read GetBaseIdFieldValue;

      property NumberFieldValue: String
      read GetNumberFieldValue;

      property NameFieldValue: String
      read GetNameFieldValue;

      property FullNameFieldValue: String
      read GetFullNameFieldValue;
      
      property ContentFieldValue: String
      read GetContentFieldValue;

      property NoteFieldValue: String
      read GetNoteFieldValue;

      property ProductCodeFieldValue: String
      read GetProductCodeFieldValue;
      
      property CreationDateFieldValue: TDateTime
      read GetCreationDateFieldValue;

      property DateFieldValue: Variant
      read GetDateFieldValue;
      
      property KindFieldValue: String
      read GetKindFieldValue;

      property KindIdFieldValue: Variant
      read GetKindIdFieldValue;

      property CurrentWorkCycleStageNameFieldValue: String
      read GetCurrentWorkCycleStageNameFieldValue;

      property CurrentWorkCycleStageNumberFieldValue: Integer
      read GetCurrentWorkCycleStageNumberFieldValue;

      property AuthorIdFieldValue: Variant
      read GetAuthorIdFieldValue;

      property AuthorLeaderIdFieldValue: Variant
      read GetAuthorLeaderIdFieldValue;

      property AuthorNameFieldValue: String
      read GetAuthorNameFieldValue;

      property AuthorSpecialityFieldValue: String
      read GetAuthorSpecialityFieldValue;
      
      property AuthorDepartmentIdFieldValue: Variant
      read GetAuthorDepartmentIdFieldValue;

      property AuthorDepartmentCodeFieldValue: String
      read GetAuthorDepartmentCodeFieldValue;

      property AuthorDepartmentNameFieldValue: String
      read GetAuthorDepartmentNameFieldValue;
      
      property ResponsibleIdFieldValue: Variant
      read GetResponsibleIdFieldValue;

      property ResponsibleNameFieldValue: String
      read GetResponsibleNameFieldValue;

      property ResponsibleTelephoneNumberFieldValue: String
      read GetResponsibleTelephoneNumberFieldValue;
      
      property ResponsibleDepartmentIdFieldValue: Variant
      read GetResponsibleDepartmentIdFieldValue;
      
      property ResponsibleDepartmentCodeFieldValue: String
      read GetResponsibleDepartmentCodeFieldValue;

      property ResponsibleDepartmentNameFieldValue: String
      read GetResponsibleDepartmentNameFieldValue;
      
      property SigningIdFieldValue: Variant
      read GetSigningIdFieldValue;

      property SigningDateFieldValue: Variant
      read GetSigningDateFieldValue;
      
      property SignerIdFieldValue: Variant
      read GetSignerIdFieldValue;

      property SignerLeaderIdFieldValue: Variant
      read GetSignerLeaderIdFieldValue;

      property SignerNameFieldValue: String
      read GetSignerNameFieldValue;

      property SignerSpecialityFieldValue: String
      read GetSignerSpecialityFieldValue;
      
      property SignerDepartmentIdFieldValue: Variant
      read GetSignerDepartmentIdFieldValue;
      
      property SignerDepartmentCodeFieldValue: String
      read GetSignerDepartmentCodeFieldValue;
      
      property SignerDepartmentNameFieldValue: String
      read GetSignerDepartmentNameFieldValue;

      property ActualSignerIdFieldValue: Variant
      read GetActualSignerIdFieldValue;

      property ActualSignerLeaderIdFieldValue: Variant
      read GetActualSignerLeaderIdFieldValue;

      property ActualSignerNameFieldValue: String
      read GetActualSignerNameFieldValue;

      property ActualSignerSpecialityFieldValue: String
      read GetActualSignerSpecialityFieldValue;
      
      property ActualSignerDepartmentIdFieldValue: Variant
      read GetActualSignerDepartmentIdFieldValue;
      
      property ActualSignerDepartmentCodeFieldValue: String
      read GetActualSignerDepartmentCodeFieldValue;
      
      property ActualSignerDepartmentNameFieldValue: String
      read GetActualSignerDepartmentNameFieldValue;

      property IsSelfRegisteredFieldValue: Variant
      read GetIsSelfRegisteredFieldValue;

  end;

implementation

uses

  Variants;
{ TDocumentInfoHolder }


function TDocumentInfoHolder.GetBaseIdFieldValue: Variant;
begin

  Result :=
    GetDataSetFieldValue(FieldNames.BaseIdFieldName, Null);

end;

class function TDocumentInfoHolder.GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass;
begin

  Result := TDocumentInfoFieldNames;
  
end;

function TDocumentInfoHolder.GetActualSignerDepartmentCodeFieldValue: String;
begin

  Result := GetDataSetFieldValue(
              FieldNames.ActualSignerDepartmentCodeFieldName,
              ''
            );

end;

function TDocumentInfoHolder.GetActualSignerDepartmentIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(FieldNames.ActualSignerDepartmentIdFieldName, Null);

end;

function TDocumentInfoHolder.GetActualSignerDepartmentNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(
              FieldNames.ActualSignerDepartmentNameFieldName,
              ''
            );

end;

function TDocumentInfoHolder.GetActualSignerIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(FieldNames.ActualSignerIdFieldName, Null);
  
end;

function TDocumentInfoHolder.GetActualSignerLeaderIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(
              FieldNames.ActualSignerLeaderIdFieldName,
              Null
            );
            
end;

function TDocumentInfoHolder.GetActualSignerNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(
              FieldNames.ActualSignerNameFieldName,
              ''
            );
  
end;

function TDocumentInfoHolder.
  GetActualSignerSpecialityFieldValue: String;
begin

  Result := GetDataSetFieldValue(
              FieldNames.ActualSignerSpecialityFieldName,
              ''
            );
            
end;

function TDocumentInfoHolder.GetAuthorDepartmentCodeFieldValue: String;
begin

  Result := GetDataSetFieldValue(FieldNames.AuthorDepartmentCodeFieldName, '');
  
end;

function TDocumentInfoHolder.GetAuthorDepartmentIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(FieldNames.AuthorDepartmentIdFieldName, Null);

end;

function TDocumentInfoHolder.GetAuthorDepartmentNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(FieldNames.AuthorDepartmentNameFieldName, '');

end;

function TDocumentInfoHolder.GetAuthorIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(FieldNames.AuthorIdFieldName, Null);

end;

function TDocumentInfoHolder.GetAuthorLeaderIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(
              FieldNames.AuthorLeaderIdFieldName,
              Null
            );
            
end;

function TDocumentInfoHolder.GetAuthorNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(FieldNames.AuthorNameFieldName, '');

end;

function TDocumentInfoHolder.GetAuthorSpecialityFieldValue: String;
begin

  Result := GetDataSetFieldValue(
              FieldNames.AuthorSpecialityFieldName,
              ''
            );
            
end;

function TDocumentInfoHolder.GetContentFieldValue: String;
begin

  Result := GetDataSetFieldValue(FieldNames.ContentFieldName, '');
  
end;

function TDocumentInfoHolder.GetCreationDateFieldValue: TDateTime;
begin

  Result := GetDataSetFieldValue(FieldNames.CreationDateFieldName, 0);
  
end;

function TDocumentInfoHolder.GetCurrentWorkCycleStageNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(FieldNames.CurrentWorkCycleStageNameFieldName, '');

end;

function TDocumentInfoHolder.GetCurrentWorkCycleStageNumberFieldValue: Integer;
begin

  Result := GetDataSetFieldValue(FieldNames.CurrentWorkCycleStageNumberFieldName, 0);

end;

function TDocumentInfoHolder.GetDateFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(FieldNames.DateFieldName, Null);
  
end;

function TDocumentInfoHolder.GetFieldNames: TDocumentInfoFieldNames;
begin

  Result := TDocumentInfoFieldNames(inherited FieldDefs);
  
end;

function TDocumentInfoHolder.GetFullNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(FieldNames.FullNameFieldName, '');
end;

function TDocumentInfoHolder.GetIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(FieldNames.IdFieldName, Null);
  
end;

function TDocumentInfoHolder.GetIsSelfRegisteredFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(FieldNames.IsSelfRegisteredFieldName, Null);

end;

function TDocumentInfoHolder.GetKindFieldValue: String;
begin

  Result := GetDataSetFieldValue(FieldNames.KindFieldName, '');
  
end;

function TDocumentInfoHolder.GetKindIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(
              FieldNames.KindIdFieldName,
              Null
            );
            
end;

function TDocumentInfoHolder.GetNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(FieldNames.NameFieldName, '');
  
end;

function TDocumentInfoHolder.GetNoteFieldValue: String;
begin

  Result := GetDataSetFieldValue(FieldNames.NoteFieldName, '');
  
end;

function TDocumentInfoHolder.GetNumberFieldValue: String;
begin

  Result := GetDataSetFieldValue(FieldNames.NumberFieldName, '');
  
end;

function TDocumentInfoHolder.GetProductCodeFieldValue: String;
begin

  Result := GetDataSetFieldValue(FieldNames.ProductCodeFieldName, '');
  
end;

function TDocumentInfoHolder.GetResponsibleDepartmentCodeFieldValue: String;
begin

  Result := GetDataSetFieldValue(FieldNames.ResponsibleDepartmentCodeFieldName, '');
  
end;

function TDocumentInfoHolder.GetResponsibleDepartmentIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(FieldNames.ResponsibleDepartmentIdFieldName, Null);

end;

function TDocumentInfoHolder.GetResponsibleDepartmentNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(FieldNames.ResponsibleDepartmentNameFieldName, '');

end;

function TDocumentInfoHolder.GetResponsibleIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(FieldNames.ResponsibleIdFieldName, Null);
  
end;

function TDocumentInfoHolder.GetResponsibleNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(FieldNames.ResponsibleNameFieldName, '');
  
end;

function TDocumentInfoHolder.GetResponsibleTelephoneNumberFieldValue: String;
begin

  Result := GetDataSetFieldValue(
              FieldNames.ResponsibleTelephoneNumberFieldName,
              ''
            );

end;

function TDocumentInfoHolder.GetSignerDepartmentCodeFieldValue: String;
begin

  Result := GetDataSetFieldValue(FieldNames.SignerDepartmentCodeFieldName, '');
  
end;

function TDocumentInfoHolder.GetSignerDepartmentIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(FieldNames.SignerDepartmentIdFieldName, Null);
  
end;

function TDocumentInfoHolder.GetSignerDepartmentNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(FieldNames.SignerDepartmentNameFieldName, '');
  
end;

function TDocumentInfoHolder.GetSignerIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(FieldNames.SignerIdFieldName, Null);
  
end;

function TDocumentInfoHolder.GetSignerLeaderIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(FieldNames.SignerLeaderIdFieldName, Null);

end;

function TDocumentInfoHolder.GetSignerNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(
              FieldNames.SignerNameFieldName,
              ''
            );

end;

function TDocumentInfoHolder.GetSignerSpecialityFieldValue: String;
begin

  Result := GetDataSetFieldValue(
              FieldNames.SignerSpecialityFieldName,
              ''
            );

end;

function TDocumentInfoHolder.GetSigningDateFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(FieldNames.SigningDateFieldName, Null);
  
end;

function TDocumentInfoHolder.GetSigningIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(FieldNames.SigningIdFieldName, Null);
  
end;

procedure TDocumentInfoHolder.SetFieldNames(
  const Value: TDocumentInfoFieldNames);
begin

  inherited FieldDefs := Value;

end;

end.
