unit StandardDocumentKindSetReadService;

interface

uses

  SDItemsService,
  DocumentKindSetHolder,
  DocumentKindSetReadService,
  NativeDocumentKindSetReadService,
  SDItem,
  SysUtils;

type

  TStandardDocumentKindSetReadService = class (TInterfacedObject, IDocumentKindSetReadService)

    private

      FNativeDocumentKindSetReadService: INativeDocumentKindSetReadService;
      FSDItemsService: ISDItemsService;

    public

      constructor Create(
        NativeDocumentKindSetReadService: INativeDocumentKindSetReadService;
        SDItemsService: ISDItemsService
      );

      function GetDocumentKindSet: TDocumentKindSetHolder;

  end;

implementation

{ TStandardDocumentKindSetReadService }

constructor TStandardDocumentKindSetReadService.Create(
  NativeDocumentKindSetReadService: INativeDocumentKindSetReadService;
  SDItemsService: ISDItemsService
);
begin

  inherited Create;

  FNativeDocumentKindSetReadService := NativeDocumentKindSetReadService;
  FSDItemsService := SDItemsService;

end;

function TStandardDocumentKindSetReadService.GetDocumentKindSet: TDocumentKindSetHolder;

var
    SDItems: TSDItems;
    SDItem: TSDItem;
begin

  Result := FNativeDocumentKindSetReadService.GetDocumentKindSet;

  if not Assigned(Result) then begin

    raise TDocumentKindSetReadServiceException.Create(
      'Не найдена информация о видах документов'
    );

  end;

  SDItems := nil;
  
  try

    { refactor:
      пересмотреть реализацию объединения
      набора данных с записями о типах док-ов и
      элементов программы SD в единый набор данных
    }
    SDItems := FSDItemsService.GetAllSDItems;

    for SDItem in SDItems do begin

      Result.Append;

      Result.DocumentKindIdFieldValue := -SDItem.Id;
      Result.TopLevelDocumentKindIdFieldValue := -SDItem.TopLevelSDItemId;
      Result.DocumentKindNameFieldValue := SDItem.Name;

      Result.Post;
      
    end;

  except

    on E: Exception do begin

      FreeAndNil(SDItems);

      Raise;

    end;

  end;

end;

end.
