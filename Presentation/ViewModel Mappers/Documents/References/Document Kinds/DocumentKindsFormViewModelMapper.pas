unit DocumentKindsFormViewModelMapper;

interface

uses

  DocumentKindSetHolder,
  DocumentKindsFormViewModel,
  DataSetBuilder,
  GlobalDocumentKindDto,
  DocumentKindDto,
  DB,
  SysUtils,
  Classes;

type

  TDocumentKindsFormViewModelMapper = class

    private

      FDataSetBuilder: IDataSetBuilder;

      function CreateDocumentKindSetHolderFrom(
        GlobalDocumentKindDtos: TGlobalDocumentKindDtos
      ): TDocumentKindSetHolder;

      function CreateDocumentKindSetFieldDefs: TDocumentKindSetFieldDefs;

      function CreateDocumentKindSetFrom(
        GlobalDocumentKindDtos: TGlobalDocumentKindDtos;
        FieldDefs: TDocumentKindSetFieldDefs
      ): TDataSet;

    public

      constructor Create(DataSetBuilder: IDataSetBuilder);

      function MapDocumentKindsFormViewModelFrom(
        GlobalDocumentKindDtos: TGlobalDocumentKindDtos
      ): TDocumentKindsFormViewModel;
      
  end;
  
implementation

{ TDocumentKindsFormViewModelMapper }

constructor TDocumentKindsFormViewModelMapper.Create(
  DataSetBuilder: IDataSetBuilder
);
begin

  inherited Create;

  FDataSetBuilder := DataSetBuilder;

end;

function TDocumentKindsFormViewModelMapper.CreateDocumentKindSetFieldDefs: TDocumentKindSetFieldDefs;
begin

  Result := TDocumentKindSetFieldDefs.Create;

  Result.DocumentKindIdFieldName := 'document_kind_id';
  Result.TopLevelDocumentKindIdFieldName := 'top_level_document_kind_id';
  Result.DocumentKindNameFieldName := 'document_kind_name';
  Result.OriginalDocumentKindNameFieldName := 'original_document_kind_name';
  
end;

function TDocumentKindsFormViewModelMapper.CreateDocumentKindSetFrom(
  GlobalDocumentKindDtos: TGlobalDocumentKindDtos;
  FieldDefs: TDocumentKindSetFieldDefs
): TDataSet;

var
    DocumentKindDto: TDocumentKindDto;
begin

  Result :=
    FDataSetBuilder
      .AddField(FieldDefs.DocumentKindIdFieldName, ftInteger)
      .AddField(FieldDefs.TopLevelDocumentKindIdFieldName, ftInteger)
      .AddField(FieldDefs.DocumentKindNameFieldName, ftString, 256)
      .AddField(FieldDefs.OriginalDocumentKindNameFieldName, ftString, 256)
      .Build;

  try

    Result.Open;
    
    for DocumentKindDto in GlobalDocumentKindDtos do begin

      Result.Append;

      Result.FieldByName(
        FieldDefs.DocumentKindIdFieldName

      ).AsVariant := DocumentKindDto.Id;

      Result.FieldByName(
        FieldDefs.TopLevelDocumentKindIdFieldName

      ).AsVariant := DocumentKindDto.TopLevelDocumentKindId;

      Result.FieldByName(
        FieldDefs.DocumentKindNameFieldName

      ).AsString := DocumentKindDto.Name;

      Result.FieldByName(
        FieldDefs.OriginalDocumentKindNameFieldName

      ).AsString := DocumentKindDto.Name;
      
      Result.Post;

    end;

  except

    on E: Exception do begin

      FreeAndNil(Result);

      Raise;
      
    end;

  end;

end;

function TDocumentKindsFormViewModelMapper.CreateDocumentKindSetHolderFrom(
  GlobalDocumentKindDtos: TGlobalDocumentKindDtos
): TDocumentKindSetHolder;

var

    DocumentKindSet: TDataSet;
    FieldDefs: TDocumentKindSetFieldDefs;
begin

  DocumentKindSet := nil;
  FieldDefs := nil;

  try

    FieldDefs := CreateDocumentKindSetFieldDefs;
    DocumentKindSet := CreateDocumentKindSetFrom(GlobalDocumentKindDtos, FieldDefs);
    
    Result := TDocumentKindSetHolder.CreateFrom(DocumentKindSet, FieldDefs);

  except

    on E: Exception do begin

      FreeAndNil(DocumentKindSet);
      FreeAndNil(FieldDefs);

      Raise;
      
    end;

  end;
  
end;

function TDocumentKindsFormViewModelMapper.MapDocumentKindsFormViewModelFrom(

  GlobalDocumentKindDtos: TGlobalDocumentKindDtos
  
): TDocumentKindsFormViewModel;

var
    DocumentKindSetHolder: TDocumentKindSetHolder;
begin

  DocumentKindSetHolder :=
    CreateDocumentKindSetHolderFrom(GlobalDocumentKindDtos);

  try

    Result :=
      TDocumentKindsFormViewModel.Create(DocumentKindSetHolder);

  except

    on E: Exception do begin

      FreeAndNil(Result);

      Raise;
      
    end;

  end;

end;

end.
