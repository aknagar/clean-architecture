using Newtonsoft.Json;

namespace Contracts;

public class QueueStatus
{
    [JsonProperty]
    public long MessageCount { get; set; }
}
