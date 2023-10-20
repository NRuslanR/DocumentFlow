unit DocumentFileSetHolderFactory;

interface

uses

  DocumentFileSetHolder,
  AbstractDataSetHolder,
  AbstractDataSetHolderFactory,
  DB,
  DataSetBuilder,
  SysUtils,
  Classes;

type

  IDocumentFileSetHolderFactory = interface (IDataSetHolderFactory)
    ['{E22C72BB-EE65-4BB2-98D5-BEA107F99D1E}']
    
    function CreateDocumentFileSetHolder: TDocumentFileSetHolder;
    
  end;
  
  TDocumentFileSetHolderFactory = class (TAbstractDataSetHolderFactory, IDocumentFileSetHolderFactory)

    protected

      function InternalCreateDataSetHolderInstance: TAbstractDataSetHolder; override;
      procedure FillDataSetFieldDefs(FieldDefs: TAbstractDataSetFieldDefs); override;

      procedure CustomizeDataSetBuilder(
        DataSetBuilder: IDataSetBuilder;
        DataSetHolder: TAbstractDataSetHolder
      ); override;
      
    public

      function CreateDocumentFileSetHolder: TDocumentFileSetHolder;
      
  end;


implementation

{ TDocumentFileSetHolderFactory }

function TDocumentFileSetHolderFactory.CreateDocumentFileSetHolder: TDocumentFileSetHolder;
begin

  Result := TDocumentFileSetHolder(CreateDataSetHolder);
  
end;

function TDocumentFileSetHolderFactory.InternalCreateDataSetHolderInstance: TAbstractDataSetHolder;
begin

  Result := TDocumentFileSetHolder.Create;

end;

procedure TDocumentFileSetHolderFactory.FillDataSetFieldDefs(
  FieldDefs: TAbstractDataSetFieldDefs);
begin

  inherited FillDataSetFieldDefs(FieldDefs);

  with TDocumentFileSetFieldDefs(FieldDefs) do begin

    FileNameFieldName := 'file_name';
    FilePathFieldName := 'file_path';

  end;

end;

procedure TDocumentFileSetHolderFactory.CustomizeDataSetBuilder(
  DataSetBuilder: IDataSetBuilder; DataSetHolder: TAbstractDataSetHolder);
begin

  inherited CustomizeDataSetBuilder(DataSetBuilder, DataSetHolder);

  with TDocumentFileSetHolder(DataSetHolder).FieldDefs do begin

    DataSetBuilder
      .AddField(FileNameFieldName, ftString, 300)
      .AddField(FilePathFieldName, ftString, 5000);
      
  end;

end;

end.
